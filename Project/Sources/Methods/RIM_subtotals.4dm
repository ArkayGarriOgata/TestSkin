//%attributes = {}
// _______
// Method: RM_AllocationRpt_EOS (commodityKey) -> csvText
// By: Mel Bohince @ 11/04/21, 04:45:42
// Description
// 
// ---------------------------------------------------- 
// Modified by: Mel Bohince (11/5/21) cache the job info and add cust & line; comma's on numbers and dot in po 
// Modified by: Mel Bohince (11/9/21) add subtotals

C_TEXT:C284($commodity; $1; $0)

$commodity:=$1  //this should be like 01@ for all or 01-SBS@ for a subgroup 

C_BOOLEAN:C305($convert)
$convert:=(Num:C11($commodity)=1)  //change LF to Sheets


If (True:C214)  //define the column and row structure and add the column labels
	C_TEXT:C284($csvToExport; $fieldDelimitor; $recordDelimitor)
	$csvToExport:=""  //this is the the text of the outputted file
	$fieldDelimitor:=","  //csv
	$recordDelimitor:="\r"
	
	C_COLLECTION:C1488($rows_c; $columns_c; $changesToBalance)
	$rows_c:=New collection:C1472  //there will be a row for the rm and each of its open po's or open allocations 
	//start with the column headings
	$columns_c:=New collection:C1472
	$columns_c.push("RM_Code")
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
	
	C_COLLECTION:C1488($al_c)
	$al_c:=ds:C1482.Raw_Materials_Allocations.all().distinct("JobForm")
	
	C_OBJECT:C1216($jml_es; $jml_e)
	$jml_es:=ds:C1482.Job_Forms_Master_Schedule.query("JobForm in :1"; $al_c)
	//use as: $jml_e:=$jml_es.query("JobForm = :1";$jf)
End if 

C_OBJECT:C1216($rm_es; $rm_e; $alloc_e)

$rm_es:=ds:C1482.Raw_Materials.query("Commodity_Key=:1 and ((ALLOCATIONS.JobForm#:2) or (PURCHASE_ITEMS.Qty_Open>:3))"; $commodity; ""; 0).orderBy("Raw_Matl_Code")

C_LONGINT:C283($totalOpenPOs; $totalOpenAllocations)  // Modified by: Mel Bohince (11/9/21) subtotals for each r/m
$totalOpenPOs:=0
$totalOpenAllocations:=0

For each ($rm_e; $rm_es; $loc_e)  //looping thru the raw material record with jobs or po's
	//output this rm
	$columns_c:=New collection:C1472
	$columns_c.push(txt_quote($rm_e.Raw_Matl_Code))
	$uom:=" ["+$rm_e.IssueUOM+"]"
	
	If (True:C214)  //Determine the vendor's name
		$vendor:=""
		For each ($loc_e; $rm_e.RM_LOCATIONS) While ($vendor="")
			If ($loc_e.PO_ITEM#Null:C1517)
				If ($loc_e.PO_ITEM.VENDOR#Null:C1517)
					$vendor:=txt_quote("{"+$loc_e.PO_ITEM.VENDOR.Name+"}")
				End if 
			End if 
		End for each 
		
		If ($vendor="")  //next try future PO
			For each ($po_e; $rm_e.PURCHASE_ITEMS) While ($vendor="")
				
				If ($po_e.VENDOR#Null:C1517)
					$vendor:=txt_quote("{"+$po_e.VENDOR.Name+"}")
				End if 
				
			End for each 
		End if 
		
		$columns_c.push($vendor)  //$vendID:=Vend_getVendorRecord ($1)
	End if 
	
	If (True:C214)  //enumerate the locations
		//get inventory information
		$locations_lookup:=New object:C1471
		For each ($loc_e; $rm_e.RM_LOCATIONS)  //build key-value pairs, roll up the po's quanities
			If (Not:C34(OB Is defined:C1231($locations_lookup; $loc_e.Location)))
				$locations_lookup[$loc_e.Location]:=0
			End if 
			$locations_lookup[$loc_e.Location]:=$locations_lookup[$loc_e.Location]+$loc_e.QtyOH
		End for each 
		
		ARRAY TEXT:C222($aLocations; 0)
		OB GET PROPERTY NAMES:C1232($locations_lookup; $aLocations)
		For ($i; 1; Size of array:C274($aLocations))
			$columns_c.push(txt_quote(String:C10($locations_lookup[$aLocations{$i}]; "###,###,##0")+"@"+$aLocations{$i}))
		End for 
		//preserve 4 columns of locations to keep balance column's position
		For ($i; 1; (4-Size of array:C274($aLocations)))
			$columns_c.push("")
		End for 
	End if 
	
	
	//add the beginning balance
	$balance:=$rm_e.RM_LOCATIONS.QtyOH.sum()
	$columns_c.push(txt_quote(String:C10($balance; "###,###,##0")))  //total onhand
	$columns_c.push($uom)
	
	If (True:C214)  //merge the job allocations with the purchase orders
		$rows_c.push($columns_c.join($fieldDelimitor))
		
		$changes_c:=New collection:C1472
		$changes_c:=$rm_e.ALLOCATIONS.toCollection("Date_Allocated,JobForm,Qty_Allocated,Qty_Issued,UOM")
		
		$purchases_c:=New collection:C1472
		$purchases_c:=$rm_e.PURCHASE_ITEMS.query("Qty_Open > 0").toCollection("ReqdDate,POItemKey,Qty_Open,Qty_Open,UM_Arkay_Issue")
		For each ($po; $purchases_c)
			$po.POItemKey:=Insert string:C231($po.POItemKey; "."; 8)
		End for each 
		
		$changes_c.combine($purchases_c)
		
		$merged_c:=New collection:C1472
		For each ($change; $changes_c)
			If (OB Is defined:C1231($change; "JobForm"))
				$openAllocation:=$change.Qty_Allocated-$change.Qty_Issued
				If ($change.UOM#$rm_e.IssueUOM) & ($convert)
					$openAllocation:=RM_LF_to_SHT($change.JobForm)
					$change.UOM:="SHT*"
				End if 
				
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
		$columns_c.push("")
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
	
	
	If ($totalOpenPOs>0) | ($totalOpenAllocations>0)  //output the subtotals
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
		
		//blank line between rm's
		$columns_c:=New collection:C1472
		$columns_c.push("")
		$rows_c.push($columns_c.join($fieldDelimitor))
	End if 
	
End for each   //raw material record with an alloc or po

If ($rows_c.length>1)
	$csvToExport:=$rows_c.join($recordDelimitor)  //prep the text to send to file
Else 
	$csvToExport:="No ' "+$commodity+" ' found."
End if 

$0:=$csvToExport

