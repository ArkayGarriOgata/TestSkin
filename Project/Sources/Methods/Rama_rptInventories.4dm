//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 04/23/15, 08:21:53
// ----------------------------------------------------
// Method: Rama_rptInventories
// Description
// provide GCAS codes, volumes and $ volume to Randy Robbins,png, per WJS, via KK
//
// Parameters
// ----------------------------------------------------

// Modified by: Mel Bohince (4/24/15) add Brown Summit and send attachment

C_LONGINT:C283($i; $numElements; $hit; $numCPN)
C_BOOLEAN:C305($atLeastOne)
C_TEXT:C284($b; $t; $r)
C_DATE:C307($yearAgo; $today)
$today:=Current date:C33
ARRAY TEXT:C222(aCPN; 0)
//Get the candidates
//Rama_Find_CPNs_On_Server ("client-side")
ARRAY TEXT:C222(aCPN; 0)
C_DATE:C307($yearAgo)
$yearAgo:=Add to date:C393($today; -1; 0; 0)
Begin SQL  //Cayey, Rama, BrownSummit
	SELECT distinct(productcode) from Customers_ReleaseSchedules where (Shipto='01666' or Shipto='02563' or Shipto='02439') and Sched_Date >= :$yearAgo into :aCPN;
End SQL

$numCPN:=Size of array:C274(aCPN)
If ($numCPN>0)
	SORT ARRAY:C229(aCPN; >)
	ARRAY LONGINT:C221($aInventory; $numCPN)
	ARRAY REAL:C219($aValue; $numCPN)
	For ($i; 1; $numCPN)  //init buckets
		$aInventory{$i}:=0
		$aValue{$i}:=0
	End for 
	
	//Load the bins
	READ ONLY:C145([Finished_Goods_Locations:35])
	QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]ProductCode:1; aCPN)
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]ProductCode:1; $aCPN; [Finished_Goods_Locations:35]QtyOH:9; $aQty)
	
	//Tally the inventory
	$numElements:=Size of array:C274($aCPN)
	uThermoInit($numElements; "Tally Bins")
	For ($i; 1; $numElements)
		$hit:=Find in array:C230(aCPN; $aCPN{$i})
		If ($hit>-1)
			$aInventory{$hit}:=$aInventory{$hit}+$aQty{$i}
		Else 
			BEEP:C151
		End if 
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	//Value the inventory
	$atLeastOne:=False:C215
	$count:=0
	$ttl_qty:=0
	$ttl_value:=0
	READ ONLY:C145([Customers_Order_Lines:41])
	$numElements:=Size of array:C274(aCPN)
	uThermoInit($numElements; "Value Inventory")
	For ($i; 1; $numElements)
		If ($aInventory{$i}>0)
			$atLeastOne:=True:C214
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=aCPN{$i})
			If (Records in selection:C76([Customers_Order_Lines:41])>0)  //we can value it
				ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13; <)  //get the most recent
				$aValue{$i}:=Round:C94($aInventory{$i}/1000*[Customers_Order_Lines:41]Price_Per_M:8; 0)
			Else 
				BEEP:C151
			End if 
			
			$count:=$count+1
			$ttl_qty:=$ttl_qty+$aInventory{$i}
			$ttl_value:=$ttl_value+$aValue{$i}
			
		End if 
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	//Output table
	If ($atLeastOne)
		$author:=Email_WhoAmI+","
		If (Count parameters:C259>0)
			distributionList:=Email_WhoAmI
		Else 
			distributionList:=Request:C163("Send to:"; $author; "OK"; "Cancel")  //Batch_GetDistributionList("RAMA")
		End if 
		
		$subject:="GCAS Inventories Cayey/BrownSummit "+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
		$prebody:="Inventory and value of items Released to Cayey or Brown Summit in the past year.  "
		$tableData:=""
		$excelData:=""
		$cr:=Char:C90(13)
		$tab:=Char:C90(9)
		
		$b:="<tr><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		$r:="</td></tr>"+Char:C90(13)
		$tableData:="<tr><td colspan=\"3\" style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"+$prebody+$r
		$excelData:=$prebody+$cr
		$tableData:=$tableData+$b+"GCAS"+$t+"Inventory"+$t+"$Value"+$r
		$excelData:=$excelData+"GCAS"+$tab+"Inventory"+$tab+"$Value"+$cr
		
		$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"
		
		$numElements:=Size of array:C274(aCPN)
		$row:=0
		uThermoInit($numElements; "Saving...")
		For ($i; 1; $numElements)
			If ($aInventory{$i}>0)
				$row:=$row+1
				If (($row%2)#0)  //alternate row color
					$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //start white $normwhite:="background-color:#ffffff"
				Else 
					$b:="<tr style=\"background-color:#fefcff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:500\">"  //`milk white, slightly darker white $milkwhite:="background-color:#fefcff"
				End if 
				$tableData:=$tableData+$b+aCPN{$i}+$t+String:C10($aInventory{$i}; "##,###,###")+$t+String:C10($aValue{$i}; "##,###,###")+$r
				$excelData:=$excelData+aCPN{$i}+$tab+String:C10($aInventory{$i}; "##,###,###")+$tab+String:C10($aValue{$i}; "##,###,###")+$cr
			End if 
			uThermoUpdate($i)
		End for 
		uThermoClose
		
		$b:="<tr><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
		$tableData:=$tableData+$b+"TOTALS ["+String:C10($count)+"]"+$t+String:C10($ttl_qty; "##,###,###")+$t+String:C10($ttl_value; "$##,###,###")+$r
		$excelData:=$excelData+$cr+"TOTALS ["+String:C10($count)+"]"+$tab+String:C10($ttl_qty; "##,###,###")+$tab+String:C10($ttl_value; "$##,###,###")+$cr
		
		docName:="Cayey_BrownSummit_Inventories_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
		$docRef:=util_putFileName(->docName)
		If ($docRef#?00:00:00?)
			SEND PACKET:C103($docRef; $excelData+$cr+$cr)
			SEND PACKET:C103($docRef; "--End of Report--"+$cr)
		End if 
		CLOSE DOCUMENT:C267($docRef)
		
		Email_html_table($subject; $prebody; $tableData; 600; distributionList; docName; $author; $author)
		
	End if 
	
Else 
	ALERT:C41("No GCAS codes found.")
End if 