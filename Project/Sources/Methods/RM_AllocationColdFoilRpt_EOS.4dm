//%attributes = {"executedOnServer":true}
// _______
// Method: RM_AllocationColdFoilRpt_EOS   ( ) -> csv report
// By: MelvinBohince @ 02/08/22, 16:11:34
// Description
// allocate cold foil by color and width  
//  instead of by RM_Code
// do this by getting collections of inventory, allocations, po 
// and substitute the VPN field for the RM_Code,
// the essentially run the normal allocation rpt algo
// ----------------------------------------------------

C_TEXT:C284($commodity; $0)
$commodity:="09@"

If (True:C214)  //define the column and row structure and add the column labels
	C_TEXT:C284($csvToExport; $fieldDelimitor; $recordDelimitor)
	$csvToExport:=""  //this is the the text of the outputted file
	$fieldDelimitor:=","  //csv
	$recordDelimitor:="\r"
	
	C_COLLECTION:C1488($rows_c; $columns_c; $changesToBalance)
	$rows_c:=New collection:C1472  //there will be a row for the rm and each of its open po's or open allocations 
	//start with the column headings
	$columns_c:=New collection:C1472
	$columns_c.push("ColdFoil")
	$columns_c.push("Vendor")
	$columns_c.push("Date")
	$columns_c.push("PO/Job")
	$columns_c.push("Orders")
	$columns_c.push("Allocations")
	$columns_c.push("Balance")
	$columns_c.push("UOM")
	$columns_c.push("Customer")
	$columns_c.push("Line")
	
	$rows_c.push($columns_c.join($fieldDelimitor))  //add the headers
End if 


If (True:C214)  // Modified by: Mel Bohince (11/5/21) cache the job info for cust name and line
	
	C_COLLECTION:C1488($al_c)  //which jobs are in play
	$al_c:=ds:C1482.Raw_Materials_Allocations.query("commdityKey = :1"; $commodity).distinct("JobForm")
	
	C_OBJECT:C1216($jml_es; $jml_e)  //cache those jobs to get the customer later
	$jml_es:=ds:C1482.Job_Forms_Master_Schedule.query("JobForm in :1"; $al_c)
	//use as: $jml_e:=$jml_es.query("JobForm = :1";$jf)
End if 



C_COLLECTION:C1488($rmVPN_c; $rm_c; $colorWidth_c; $rml_c)
//build a key value pair of rm_code to color-width (aka VPN) that will be used to substitute color and width for the RM_code
$rmVPN_c:=ds:C1482.Raw_Materials.query("Commodity_Key=:1 and ((ALLOCATIONS.JobForm#:2) or (PURCHASE_ITEMS.Qty_Open>:3)or (RM_LOCATIONS.QtyOH>:4))"; $commodity; ""; 0; 0).orderBy("Raw_Matl_Code").toCollection("Raw_Matl_Code, VendorPartNum")

//translate the RM_code into the color-width key value pair so RM_codes can be replaced with the important attribute
// to use like $obj.Raw_Matl_Code:=$rmToColorWidth[$obj.Raw_Matl_Code] //'icf-100' becomes 'silver-20'
$rmToColorWidth:=New object:C1471
For each ($obj; $rmVPN_c)
	$rmToColorWidth[$obj.Raw_Matl_Code]:=$obj.VendorPartNum  //'icf-100' : 'silver-20'
End for each 

ARRAY TEXT:C222($_rmCodes; 0)  //will need this later to enumerate which rm codes belong to the psuedo rm code
OB GET PROPERTY NAMES:C1232($rmToColorWidth; $_rmCodes)

//collection of interesting rm codes for doing queries in location, alllocations, and poi
$rm_c:=$rmVPN_c.extract("Raw_Matl_Code")

//get the allocations
$rma_c:=ds:C1482.Raw_Materials_Allocations.query("Raw_Matl_Code in :1"; $rm_c).toCollection("Raw_Matl_Code,Date_Allocated,JobForm,Qty_Allocated,Qty_Issued,UOM")
For each ($obj; $rma_c)  //do the substitution
	$obj.Raw_Matl_Code:=$rmToColorWidth[$obj.Raw_Matl_Code]
End for each 

//get the po items
$poi_c:=ds:C1482.Purchase_Orders_Items.query("Raw_Matl_Code in :1 and Qty_Open > :2"; $rm_c; 0).toCollection("Raw_Matl_Code,ReqdDate,POItemKey,Qty_Open,Qty_Open,UM_Arkay_Issue,VendorID,ExpeditingNote")
For each ($obj; $poi_c)  //do the substitution
	$obj.Raw_Matl_Code:=$rmToColorWidth[$obj.Raw_Matl_Code]
	$vendor_e:=ds:C1482.Vendors.query("ID = :1"; $obj.VendorID).first()  //get the vendor name, 
	If ($vendor_e#Null:C1517)
		$obj.ExpeditingNote:=$vendor_e.Name  //ExpeditingNote was just a convenient text field to hold the vendorname instead of adding element to each obj in the collection
	Else 
		$obj.ExpeditingNote:="vendor not found"
	End if 
End for each 

//get the rm locations
$rml_c:=ds:C1482.Raw_Materials_Locations.query("Raw_Matl_Code in :1"; $rm_c).toCollection("Raw_Matl_Code, QtyOH")  //will need to use .sum() when querying color
For each ($obj; $rml_c)  //do the substitution
	$obj.Raw_Matl_Code:=$rmToColorWidth[$obj.Raw_Matl_Code]
End for each 

C_LONGINT:C283($totalOpenPOs; $totalOpenAllocations)  // Modified by: Mel Bohince (11/9/21) subtotals for each r/m
$totalOpenPOs:=0
$totalOpenAllocations:=0

$colorWidth_c:=$rmVPN_c.distinct("VendorPartNum")  //find the base list of color-width combinations, these become the main section of the report

For ($i; 0; $colorWidth_c.length-1)  //looping thru base list of color-width combinations
	$psudoRMcode:=$colorWidth_c[$i]
	//output this rm
	$columns_c:=New collection:C1472
	$columns_c.push(txt_quote($psudoRMcode))
	//enumerate real rm_codes in play from attributes of $rmToColorWidth
	$columns_c.push("")
	$fillColumns:=4
	For ($rm; 1; Size of array:C274($_rmCodes))  //may be a better way, but idk what it is
		If (OB Get:C1224($rmToColorWidth; $_rmCodes{$rm})=$psudoRMcode)  //this rm code is a member of the color-width
			$columns_c.push($_rmCodes{$rm})
			$fillColumns:=$fillColumns-1
		End if 
	End for 
	For ($col; 1; $fillColumns)  //maintain column spacing
		$columns_c.push("")
	End for 
	
	//add the beginning balance
	$balance:=$rml_c.query("Raw_Matl_Code = :1"; $psudoRMcode).sum("QtyOH")
	$columns_c.push(txt_quote(String:C10($balance; "###,###,##0")))  //total onhand
	$columns_c.push(" [Roll]")
	
	If (True:C214)  //merge the job allocations with the purchase orders
		$rows_c.push($columns_c.join($fieldDelimitor))
		
		$changes_c:=$rma_c.query("Raw_Matl_Code = :1"; $psudoRMcode)
		
		$purchases_c:=$poi_c.query("Raw_Matl_Code = :1"; $psudoRMcode)
		
		For each ($po; $purchases_c)  //make the poitem more glamorous
			$po.POItemKey:=Insert string:C231($po.POItemKey; "."; 8)  //1234567.89
		End for each 
		
		$changes_c.combine($purchases_c)
		
		$merged_c:=New collection:C1472
		For each ($change; $changes_c)
			If (OB Is defined:C1231($change; "JobForm"))
				$openAllocation:=$change.Qty_Allocated-$change.Qty_Issued
				
				$merged_c.push(New object:C1471("date"; $change.Date_Allocated; "reference"; $change.JobForm; "decrement"; $openAllocation; "increment"; 0; "balance"; 0; "UOM"; $change.UOM))
			Else 
				$merged_c.push(New object:C1471("date"; $change.ReqdDate; "reference"; $change.POItemKey; "decrement"; 0; "increment"; $change.Qty_Open; "balance"; 0; "UOM"; $change.UM_Arkay_Issue))
			End if 
		End for each   //combined event
		
		$merged_c:=$merged_c.orderBy("date asc")
	End if 
	
	For each ($event; $merged_c)  //print the running balance
		$columns_c:=New collection:C1472
		
		$columns_c.push("")
		If (Length:C16($event.reference)<10)  //ref is a job
			$columns_c.push("")
		Else 
			$vendorName:=$poi_c.query("POItemKey = :1"; $event.reference)[0].ExpeditingNote
			$columns_c.push(txt_quote($vendorName))
		End if 
		$columns_c.push(String:C10($event.date; Internal date short special:K1:4))
		$columns_c.push($event.reference)
		$columns_c.push(txt_quote(String:C10($event.increment; "###,###,##0")))
		$columns_c.push(txt_quote(String:C10($event.decrement; "###,###,##0")))
		$balance:=$balance+$event.increment-$event.decrement
		$columns_c.push(txt_quote(String:C10($balance; "###,###,##0")))
		$columns_c.push($event.UOM)
		If (Length:C16($event.reference)<10)  //ref is a job
			$jml_e:=$jml_es.query("JobForm = :1"; $event.reference).first()
			$columns_c.push(txt_quote($jml_e.Customer))
			$columns_c.push(txt_quote($jml_e.Line))
			
		Else   //its a po item key
			$columns_c.push("")
			$columns_c.push("")
		End if 
		
		$rows_c.push($columns_c.join($fieldDelimitor))
		
		// Modified by: Mel Bohince (11/9/21) add subtotals, accumlate here
		$totalOpenAllocations:=$totalOpenAllocations+$event.decrement
		$totalOpenPOs:=$totalOpenPOs+$event.increment
		
	End for each   //allocation or purchase order
	
	If ($totalOpenPOs>0) | ($totalOpenAllocations>0)  // Modified by: Mel Bohince (11/9/21) output subtotals,
		$columns_c:=New collection:C1472
		$columns_c.push("")  //-----
		$columns_c.push("")
		$columns_c.push("")
		$columns_c.push("TOTALS:")
		$columns_c.push(txt_quote(String:C10($totalOpenPOs; "###,###,##0")))
		$columns_c.push(txt_quote(String:C10($totalOpenAllocations; "###,###,##0")))
		$columns_c.push("")
		$rows_c.push($columns_c.join($fieldDelimitor))
		
		$totalOpenPOs:=0  //reset
		$totalOpenAllocations:=0
		
	End if 
	
	//blank line between rm's
	$columns_c:=New collection:C1472
	$columns_c.push("")
	$rows_c.push($columns_c.join($fieldDelimitor))
	
End for   //raw material record with an alloc or po or onhand

If ($rows_c.length>1)
	$csvToExport:=$rows_c.join($recordDelimitor)  //prep the text to send to file
Else 
	$csvToExport:="No ' "+$commodity+" ' found."
End if 

$0:=$csvToExport

