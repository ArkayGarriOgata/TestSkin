//%attributes = {}
// -------
// Method: Ord_backlog   ( ) ->
// By: Mel Bohince @ 09/09/16, 09:05:30
// Description
// of the open orders, what is already covered by inventory and what will need produced
// ----------------------------------------------------
// Modified by: Mel Bohince (9/20/16) fix percent comparison problem caused by unit price approximation

C_LONGINT:C283($i; $numElements; $total)
$total:=0

C_TEXT:C284($title; $text; $docName; $0)
C_TIME:C306($docRef)
ARRAY TEXT:C222($aProductCode; 0)
ARRAY REAL:C219($aPrice; 0)
ARRAY LONGINT:C221($aOpenQty; 0)

//Find the open orders

Begin SQL
	SELECT ProductCode, Price_Per_M, Qty_Open
	from Customers_Order_Lines
	where SpecialBilling = false and
	Qty_Open > 0 and
	UPPER(Status) not in ('CLOSED', 'CANCEL', 'CANCELLED', 'KILL', 'NEW', 'CONTRACT', 'OPENED', 'CREDIT HOLD', 'HOLD', 'REJECTED')
	ORDER BY ProductCode 
	into :$aProductCode, :$aPrice, :$aOpenQty
End SQL

ARRAY TEXT:C222($aCPNsummary; 0)
ARRAY REAL:C219($aExtPrice; 0)
ARRAY LONGINT:C221($aOpenQtySummary; 0)
ARRAY REAL:C219($aUnitPrice; 0)

//Group by ProductCode

$numElements:=Size of array:C274($aProductCode)
$currentCPN:=""
$cursor:=0
uThermoInit($numElements; "Condensing product...")
For ($i; 1; $numElements)
	If ($currentCPN#$aProductCode{$i})
		$cursor:=$cursor+1
		APPEND TO ARRAY:C911($aCPNsummary; $aProductCode{$i})
		APPEND TO ARRAY:C911($aExtPrice; 0)
		APPEND TO ARRAY:C911($aOpenQtySummary; 0)
		APPEND TO ARRAY:C911($aUnitPrice; 0)
		$currentCPN:=$aProductCode{$i}
		
	End if 
	$aOpenQtySummary{$cursor}:=$aOpenQtySummary{$cursor}+$aOpenQty{$i}
	$aExtPrice{$cursor}:=$aExtPrice{$cursor}+Round:C94(($aOpenQty{$i}/1000*$aPrice{$i}); 0)
	
	If ($aPrice{$i}>$aUnitPrice{$cursor})
		$aUnitPrice{$cursor}:=$aPrice{$i}
	End if 
	uThermoUpdate($i)
End for 
uThermoClose


//Compare to Invnetory

$numElements:=Size of array:C274($aCPNsummary)
ARRAY LONGINT:C221($aOnHand; $numElements)
ARRAY LONGINT:C221($aShipBklog; $numElements)
ARRAY LONGINT:C221($aMfgBklog; $numElements)
ARRAY LONGINT:C221($aReady; $numElements)
ARRAY LONGINT:C221($aNeed; $numElements)
$price:=1
uThermoInit($numElements; "Finding inventory...")
For ($i; 1; $numElements)
	$onhand:=0
	$cpn:=$aCPNsummary{$i}
	Begin SQL
		select sum(QtyOH) from Finished_Goods_Locations where ProductCode = :$cpn group by ProductCode into :$onhand
	End SQL
	
	$aOnHand{$i}:=$onhand
	If ($onhand>$aOpenQtySummary{$i})
		$aShipBklog{$i}:=Round:C94($aOpenQtySummary{$i}/1000*$aUnitPrice{$i}; 0)
		$aReady{$i}:=$aOpenQtySummary{$i}
	Else 
		$aShipBklog{$i}:=Round:C94($onhand/1000*$aUnitPrice{$i}; 0)
		$aReady{$i}:=$onhand
	End if 
	
	If ($onhand<$aOpenQtySummary{$i})
		$aMfgBklog{$i}:=Round:C94(($aOpenQtySummary{$i}-$onhand)/1000*$aUnitPrice{$i}; 0)
		$aNeed{$i}:=$aOpenQtySummary{$i}-$onhand
	Else 
		$aMfgBklog{$i}:=0
		$aNeed{$i}:=0
	End if 
	
	uThermoUpdate($i)
End for 
uThermoClose


//Report
$ttOO:=0
$ttOH:=0
$ttOV:=0
$ttCL:=0
$ttBL:=0
$ttCLQ:=0
$ttBLQ:=0
If (Count parameters:C259=0)
	$title:="Comparison of Open Order against Exsisting Inventory, using max unit price for totals"
	$text:=""
	$docName:="OrderBackLog"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".xls"
	$docRef:=util_putFileName(->$docName)
	
	If ($docRef#?00:00:00?)
		SEND PACKET:C103($docRef; $title+"\r\r")
		
		$text:=$text+"PRODUCT_CODE"+"\t"+"OPEN_ORDER"+"\t"+"ON_HAND"+"\t"+"$VALUE"+"\t"+"$LIABILITY"+"\t"+"$BACK_LOG"+"\t"+"READY_QTY"+"\t"+"MFG_QTY"+"\r"
		
		uThermoInit($numElements; "Finding inventory...")
		For ($i; 1; $numElements)
			If (Length:C16($text)>25000)
				SEND PACKET:C103($docRef; $text)
				$text:=""
			End if 
			$ttOO:=$ttOO+$aOpenQtySummary{$i}
			$ttOH:=$ttOH+$aOnHand{$i}
			$ttOV:=$ttOV+$aExtPrice{$i}
			$ttCL:=$ttCL+$aShipBklog{$i}
			$ttBL:=$ttBL+$aMfgBklog{$i}
			$ttCLQ:=$ttCLQ+$aReady{$i}
			$ttBLQ:=$ttBLQ+$aNeed{$i}
			$text:=$text+$aCPNsummary{$i}+"\t"+String:C10($aOpenQtySummary{$i})+"\t"+String:C10($aOnHand{$i})+"\t"+String:C10($aExtPrice{$i})+"\t"+String:C10($aShipBklog{$i})+"\t"+String:C10($aMfgBklog{$i})+"\t"+String:C10($aReady{$i})+"\t"+String:C10($aNeed{$i})+"\r"
			uThermoUpdate($i)
		End for 
		$pctBasis:=$ttCL+$ttBL  // Modified by: Mel Bohince (9/20/16) fix percent comparison problem caused by unit price approximation
		$text:=$text+"\rTOTALS:"+"\t"+String:C10($ttOO)+"\t"+String:C10($ttOH)+"\t"+String:C10($ttOV)+"\t"+String:C10($ttCL)+"\t"+String:C10($ttBL)+"\t"+String:C10($ttCLQ)+"\t"+String:C10($ttBLQ)+"\r"
		$text:=$text+"RATIOS"+"\t"+""+"\t"+String:C10(Round:C94($ttOH/$ttOO*100; 0))+"\t"+""+"\t"+String:C10(Round:C94($ttCL/$pctBasis*100; 0))+"\t"+String:C10(Round:C94($ttBL/$pctBasis*100; 0))+"\t"+String:C10(Round:C94($ttCLQ/$ttOO*100; 0))+"\t"+String:C10(Round:C94($ttBLQ/$ttOO*100; 0))+"\r"
		
		SEND PACKET:C103($docRef; $text)
		SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		
		$err:=util_Launch_External_App($docName)
		$0:=$docName
	Else 
		$0:="failed"
	End if 
	
Else   //just summary
	For ($i; 1; $numElements)
		$ttOO:=$ttOO+$aOpenQtySummary{$i}
		$ttOH:=$ttOH+$aOnHand{$i}
		$ttOV:=$ttOV+$aExtPrice{$i}
		$ttCL:=$ttCL+$aShipBklog{$i}
		$ttBL:=$ttBL+$aMfgBklog{$i}
	End for 
	$pctBasis:=$ttCL+$ttBL  // Modified by: Mel Bohince (9/20/16) fix percent comparison problem caused by unit price approximation
	$dollars:=String:C10(Round:C94($ttOV/1000000; 1); "$##0.0")+" million"
	$text:=" Current value of open orders is "+$dollars+"; "+String:C10(Round:C94($ttCL/$pctBasis*100; 0))+"% is in inventory; "+String:C10(Round:C94($ttBL/$pctBasis*100; 0))+"% is backlogged. "
	//$text:=$text+" run the Order Backlog report for details."
	$0:=$text
End if 
