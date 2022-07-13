//%attributes = {"publishedWeb":true}
// Method: PnG_Billable60Day () -> 
// ----------------------------------------------------
// was`PM: rProctorAndGamble3() -> 
//@author mlb - 2/19/03  13:36
//find billable 60 day old stuff

C_LONGINT:C283($i; $j; $numElements; $numJMI; $dayLimit)
C_DATE:C307($cutOffDate)
ARRAY LONGINT:C221($aRecNo; 0)
ARRAY TEXT:C222($aCPN; 0)
ARRAY LONGINT:C221($aQty; 0)
ARRAY TEXT:C222($aJobit; 0)
ARRAY DATE:C224($aGlued; 0)

If (Count parameters:C259>0)
	$custid:=$1
	$dayLimit:=$2
Else 
	$custid:="00199"
	$dayLimit:=60
End if 
$cutOffDate:=4D_Current_date-$dayLimit

READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Job_Forms_Items:44])
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16=$custid; *)
QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2#"BH@")

SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]; $aRecNo; [Finished_Goods_Locations:35]ProductCode:1; $aCPN; [Finished_Goods_Locations:35]QtyOH:9; $aQty; [Finished_Goods_Locations:35]Jobit:33; $aJobit)
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
$numElements:=Size of array:C274($aCPN)
If ($numElements>0)
	ARRAY DATE:C224($aGlued; $numElements)
	SORT ARRAY:C229($aJobit; $aCPN; $aQty; $aRecNo; >)
	
	uThermoInit($numElements; "Finding Glue Dates...")
	For ($i; 1; $numElements)
		$numJMI:=qryJMI($aJobit{$i})
		If ($numJMI>0)
			$aGlued{$i}:=[Job_Forms_Items:44]Glued:33
		End if 
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	SORT ARRAY:C229($aGlued; $aJobit; $aCPN; $aQty; $aRecNo; <)  //latest to earliest, 00/00 at bottom
	$numElements:=Find in array:C230($aGlued; !00-00-00!)  //remove the 00/00's
	If ($numElements>-1)
		ARRAY LONGINT:C221($aRecNo; ($numElements-1))
		ARRAY TEXT:C222($aCPN; ($numElements-1))
		ARRAY LONGINT:C221($aQty; ($numElements-1))
		ARRAY TEXT:C222($aJobit; ($numElements-1))
		ARRAY DATE:C224($aGlued; ($numElements-1))
	End if 
	
	SORT ARRAY:C229($aGlued; $aJobit; $aCPN; $aQty; $aRecNo; >)  //earlist to latest
	$numElements:=1
	While ($aGlued{$numElements}<=$cutOffDate)
		$numElements:=$numElements+1
	End while 
	
	ARRAY LONGINT:C221($aRecNo; $numElements)
	ARRAY TEXT:C222($aCPN; $numElements)
	ARRAY LONGINT:C221($aQty; $numElements)
	ARRAY TEXT:C222($aJobit; $numElements)
	ARRAY DATE:C224($aGlued; $numElements)
	If (False:C215)
		CREATE SET FROM ARRAY:C641([Finished_Goods_Locations:35]; $aRecNo; "sixtyDayOld")
		USE SET:C118("sixtyDayOld")
		CLEAR SET:C117("sixtyDayOld")
	End if 
	
	SORT ARRAY:C229($aCPN; $aGlued; $aJobit; $aQty; $aRecNo; >)  //consolidate by cpn
	ARRAY TEXT:C222(aCPN; $numElements)
	ARRAY LONGINT:C221(aQty; $numElements)
	
	uThermoInit($numElements; "Consolidating Qtys by CPN...")
	$currentCPN:=""
	$cursor:=0
	For ($i; 1; $numElements)
		If ($aCPN{$i}#$currentCPN)
			$cursor:=$cursor+1
			aCPN{$cursor}:=$aCPN{$i}
			aQty{$cursor}:=0
			$currentCPN:=$aCPN{$i}
		End if 
		aQty{$cursor}:=aQty{$cursor}+$aQty{$i}
		
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	ARRAY TEXT:C222(aCPN; $cursor)
	ARRAY LONGINT:C221(aQty; $cursor)
	$numElements:=$cursor
	
	uThermoInit($numElements; "Looking for open orders...")
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$custid)
		$numOrds:=qryOpenOrdLines("0"; "*")
		
		
	Else 
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$custid; *)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)  //see also same search in doFGRptRecords
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Closed"; *)  //•080195  MLB 1490
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel"; *)  //•080195  MLB 1490
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
		
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
		
		CREATE SET:C116([Customers_Order_Lines:41]; "openOrders")
		
		
	Else 
		
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	C_TEXT:C284($t; $cr)
	$t:=Char:C90(9)
	$cr:=Char:C90(13)
	
	xTitle:="P&G BILLABLE ITEMS "+TS2String(TSTimeStamp)
	xText:="ORDER_LINE"+$t+"PRODUCT_CODE"+$t+"QUANTITY"+$t+"EXTENDED$"+$cr
	For ($i; 1; $numElements)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			USE SET:C118("openOrders")
			QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=aCPN{$i})
			
			
		Else 
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$custid; *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)  //see also same search in doFGRptRecords
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Closed"; *)  //•080195  MLB 1490
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel"; *)  //•080195  MLB 1490
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215; *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=aCPN{$i})
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			$numRecs:=Records in selection:C76([Customers_Order_Lines:41])
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				For ($j; 1; $numRecs)
					If (aQty{$i}>0)
						$allowedOverRun:=Round:C94(([Customers_Order_Lines:41]OverRun:25/100)*[Customers_Order_Lines:41]Quantity:6; 0)
						$qtyAllowed:=$allowedOverRun+[Customers_Order_Lines:41]Qty_Open:11
						If (aQty{$i}>=$qtyAllowed)
							xText:=xText+[Customers_Order_Lines:41]OrderLine:3+$t+[Customers_Order_Lines:41]ProductCode:5+$t+String:C10($qtyAllowed)+$t+String:C10($qtyAllowed/1000*[Customers_Order_Lines:41]Price_Per_M:8)+$cr
							aQty{$i}:=aQty{$i}-$qtyAllowed
						Else 
							xText:=xText+[Customers_Order_Lines:41]OrderLine:3+$t+[Customers_Order_Lines:41]ProductCode:5+$t+String:C10(aQty{$i})+$t+String:C10(aQty{$i}/1000*[Customers_Order_Lines:41]Price_Per_M:8)+$cr
							aQty{$i}:=0
						End if 
					End if 
					NEXT RECORD:C51([Customers_Order_Lines:41])
				End for 
				
			Else 
				
				ARRAY REAL:C219($_OverRun; 0)
				ARRAY LONGINT:C221($_Quantity; 0)
				ARRAY LONGINT:C221($_Qty_Open; 0)
				ARRAY TEXT:C222($_OrderLine; 0)
				ARRAY TEXT:C222($_ProductCode; 0)
				ARRAY REAL:C219($_Price_Per_M; 0)
				
				
				SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OverRun:25; $_OverRun; [Customers_Order_Lines:41]Quantity:6; $_Quantity; [Customers_Order_Lines:41]Qty_Open:11; $_Qty_Open; [Customers_Order_Lines:41]OrderLine:3; $_OrderLine; [Customers_Order_Lines:41]ProductCode:5; $_ProductCode; [Customers_Order_Lines:41]Price_Per_M:8; $_Price_Per_M)
				
				
				
				For ($j; 1; $numRecs; 1)
					If (aQty{$i}>0)
						$allowedOverRun:=Round:C94(($_OverRun{$j}/100)*$_Quantity{$j}; 0)
						$qtyAllowed:=$allowedOverRun+$_Qty_Open{$j}
						If (aQty{$i}>=$qtyAllowed)
							xText:=xText+$_OrderLine{$j}+$t+$_ProductCode{$j}+$t+String:C10($qtyAllowed)+$t+String:C10($qtyAllowed/1000*$_Price_Per_M{$j})+$cr
							aQty{$i}:=aQty{$i}-$qtyAllowed
						Else 
							xText:=xText+$_OrderLine{$j}+$t+$_ProductCode{$j}+$t+String:C10(aQty{$i})+$t+String:C10(aQty{$i}/1000*$_Price_Per_M{$j})+$cr
							aQty{$i}:=0
						End if 
					End if 
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
		End if 
		uThermoUpdate($i)
	End for 
	uThermoClose
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		CLEAR SET:C117("openOrders")
		CLEAR SET:C117("openOrders")
		
		
	Else 
		
		
		
	End if   // END 4D Professional Services : January 2019 
	zwStatusMsg("P&G Rpt"; "Saving to filename: PnG_billable.txt")
	rPrintText("PnG_billable.txt")
	
End if 