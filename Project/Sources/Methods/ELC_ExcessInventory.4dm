//%attributes = {"publishedWeb":true}
//PM: ELC_ExcessInventory() -> 
//@author mlb - 10/4/01  10:30
// • mel (5/25/05, 08:48:34) remove bill and holds

C_TIME:C306($docRef)
C_LONGINT:C283($i; $numBins; $binCursor)
C_TEXT:C284($t; $cr)
C_TEXT:C284(xTitle; xText)

MESSAGES OFF:C175
zwStatusMsg("Estée Lauder"; "Excess Report")
$t:=Char:C90(9)
$cr:=Char:C90(13)
xTitle:=""
xText:=""
//report excess qtys (no order release or forecasts)
READ ONLY:C145([Customers:16])
READ ONLY:C145([Finished_Goods_Locations:35])

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
	
	$numBins:=ELC_query(->[Finished_Goods_Locations:35]CustID:16)
	QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"BH")  // • mel (5/25/05, 08:48:34) remove bill and holds
	
	
Else 
	
	$critiria:=ELC_getName
	QUERY BY FORMULA:C48([Finished_Goods_Locations:35]; ([Finished_Goods_Locations:35]CustID:16=[Customers:16]ID:1) & ([Customers:16]ParentCorp:19=$critiria) & ([Finished_Goods_Locations:35]Location:2#"BH"))
	
	
End if   // END 4D Professional Services : January 2019 ELC_query
ARRAY TEXT:C222($aCust; 0)
ARRAY TEXT:C222($aCPN; 0)
ARRAY LONGINT:C221($aQtyOH; 0)
SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]CustID:16; $aCust; [Finished_Goods_Locations:35]ProductCode:1; $aCPN; [Finished_Goods_Locations:35]QtyOH:9; $aQtyOH)
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)

$numBins:=Size of array:C274($aCust)
//*Over allocate array sizes for now
ARRAY TEXT:C222($aFGKey; 0)
ARRAY TEXT:C222($aFGKey; $numBins)
For ($i; 1; $numBins)  //•022497  MLB  build sort key
	$aFGKey{$i}:=$aCust{$i}+":"+$aCPN{$i}
End for 
ARRAY TEXT:C222($aCust; 0)
ARRAY TEXT:C222($aCPN; 0)
SORT ARRAY:C229($aFGKey; $aQtyOH; >)

ARRAY TEXT:C222(<>aFGKey; 0)
ARRAY LONGINT:C221(<>aQty_FG; 0)
ARRAY TEXT:C222(<>aFGKey; $numBins)
ARRAY LONGINT:C221(<>aQty_FG; $numBins)

$binCursor:=0  //track the use of above arrays
//*Tally the inventory bins
uThermoInit($numBins; "Estee Lauder Inventory Roll-up")
For ($i; 1; $numBins)
	//*     Set up a bucket  
	If (<>aFGKey{$binCursor}#$aFGKey{$i})
		$binCursor:=$binCursor+1
		<>aFGKey{$binCursor}:=$aFGKey{$i}
	End if 
	<>aQty_FG{$binCursor}:=<>aQty_FG{$binCursor}+$aQtyOH{$i}
	uThermoUpdate($i)
End for 
ARRAY TEXT:C222($aFGKey; 0)
ARRAY LONGINT:C221($aQtyOH; 0)
uThermoClose
//*Shrink arrays to fit
ARRAY TEXT:C222(<>aFGKey; $binCursor)
ARRAY LONGINT:C221(<>aQty_FG; $binCursor)
ARRAY LONGINT:C221(<>aQty_EX; 0)
ARRAY LONGINT:C221(<>aQty_EX; $binCursor)

uThermoInit($binCursor; "Estee Lauder Determine Excess")
For ($i; 1; $binCursor)
	<>aQty_EX{$i}:=0
	//first look to see if its covered by releases  
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12=(Substring:C12(<>aFGKey{$i}; 1; 5)); *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=(Substring:C12(<>aFGKey{$i}; 7)); *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
	$qtyReleased:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
	If ($qtyReleased<<>aQty_FG{$i})
		<>aQty_EX{$i}:=<>aQty_FG{$i}-$qtyReleased
	End if 
	uThermoUpdate($i)
End for 
uThermoClose

uThermoInit($binCursor; "Estee Lauder Reviewing Excess")
For ($i; 1; $binCursor)
	If (<>aQty_EX{$i}>0)  //not enough releases from prior pass
		//determine if there is unreleased order qtys  
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=(Substring:C12(<>aFGKey{$i}; 1; 5)); *)
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]ProductCode:5=(Substring:C12(<>aFGKey{$i}; 7)))
			$openOrds:=qryOpenOrdLines(""; "*")
			
		Else 
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=(Substring:C12(<>aFGKey{$i}; 1; 5)); *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=(Substring:C12(<>aFGKey{$i}; 7)); *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Closed"; *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel"; *)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
			
			$openOrds:=Records in selection:C76([Customers_Order_Lines:41])
			
		End if   // END 4D Professional Services : January 2019 First record
		
		If ($openOrds>0)
			$qtyDemand:=0
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				For ($j; 1; $openOrds)
					$overrun:=[Customers_Order_Lines:41]Quantity:6*([Customers_Order_Lines:41]OverRun:25/100)
					$qtyOpenOrder:=[Customers_Order_Lines:41]Qty_Open:11+$overrun
					$qtyDemand:=$qtyDemand+$qtyOpenOrder
					NEXT RECORD:C51([Customers_Order_Lines:41])
				End for 
				
			Else 
				
				ARRAY LONGINT:C221($_Quantity; 0)
				ARRAY REAL:C219($_OverRun; 0)
				ARRAY LONGINT:C221($_Qty_Open; 0)
				
				SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Quantity:6; $_Quantity; [Customers_Order_Lines:41]OverRun:25; $_OverRun; [Customers_Order_Lines:41]Qty_Open:11; $_Qty_Open)
				
				For ($j; 1; $openOrds; 1)
					$overrun:=$_Quantity{$j}*($_OverRun{$j}/100)
					$qtyOpenOrder:=$_Qty_Open{$j}+$overrun
					$qtyDemand:=$qtyDemand+$qtyOpenOrder
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
			//get the releases
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12=(Substring:C12(<>aFGKey{$i}; 1; 5)); *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=(Substring:C12(<>aFGKey{$i}; 7)); *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
			$qtyReleased:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
			//consume the forecasts
			Case of 
				: ($qtyReleased<$qtyDemand)
					$qtyDemand:=$qtyDemand
				: ($qtyReleased>=$qtyDemand)
					$qtyDemand:=$qtyReleased
			End case 
			
			If ($qtyDemand<<>aQty_FG{$i})
				<>aQty_EX{$i}:=<>aQty_FG{$i}-$qtyDemand
			Else 
				<>aQty_EX{$i}:=0
			End if 
		End if   //orders 
	End if   //excess  
	uThermoUpdate($i)
End for 
uThermoClose

//see if excess had been glued
ARRAY LONGINT:C221(<>aQty_CC; 0)
ARRAY LONGINT:C221(<>aQty_CC; $binCursor)

uThermoInit($binCursor; "Estee Lauder Reviewing Production")
For ($i; 1; $binCursor)
	<>aQty_CC{$i}:=0
	If (<>aQty_EX{$i}>0)  //not enough releases from prior pass
		$numJMI:=qryJMI("@"; 0; Substring:C12(<>aFGKey{$i}; 7))
		If ($numJMI>0)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				For ($j; 1; $numJMI)
					If ([Job_Forms_Items:44]FormClosed:5)
						$qtyProduced:=[Job_Forms_Items:44]Qty_Good:10
					Else 
						$qtyProduced:=[Job_Forms_Items:44]Qty_Actual:11
					End if 
					If ($qtyProduced>[Job_Forms_Items:44]Qty_Want:24)
						<>aQty_CC{$i}:=$qtyProduced-[Job_Forms_Items:44]Qty_Want:24
					End if 
					NEXT RECORD:C51([Job_Forms_Items:44])
				End for 
				
			Else 
				
				ARRAY BOOLEAN:C223($_FormClosed; 0)
				ARRAY LONGINT:C221($_Qty_Good; 0)
				ARRAY LONGINT:C221($_Qty_Actual; 0)
				ARRAY LONGINT:C221($_Qty_Want; 0)
				
				SELECTION TO ARRAY:C260([Job_Forms_Items:44]FormClosed:5; $_FormClosed; [Job_Forms_Items:44]Qty_Good:10; $_Qty_Good; [Job_Forms_Items:44]Qty_Actual:11; $_Qty_Actual; [Job_Forms_Items:44]Qty_Want:24; $_Qty_Want)
				
				For ($j; 1; $numJMI; 1)
					If ($_FormClosed{$j})
						$qtyProduced:=$_Qty_Good{$j}
					Else 
						$qtyProduced:=$_Qty_Actual{$j}
					End if 
					If ($qtyProduced>$_Qty_Want{$j})
						<>aQty_CC{$i}:=$qtyProduced-$_Qty_Want{$j}
					End if 
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
		End if 
	End if   //excess  
	uThermoUpdate($i)
End for 
uThermoClose

//look for reasons
ARRAY TEXT:C222($aReasons; 0)
ARRAY TEXT:C222($aReasons; $binCursor)
ARRAY TEXT:C222($aLine; 0)
ARRAY TEXT:C222($aLine; $binCursor)

uThermoInit($binCursor; "Estee Lauder Looking for reasons")
For ($i; 1; $binCursor)
	If (<>aQty_EX{$i}>0)  //not enough releases from prior pass
		$numJMI:=qryFinishedGood("#KEY"; <>aFGKey{$i})
		$aLine{$i}:=[Finished_Goods:26]Line_Brand:15
		$aReasons{$i}:=""
		$cpn:=Substring:C12(<>aFGKey{$i}; 7)
		
		If (Position:C15("Obsolete"; [Finished_Goods:26]Status:14)>0)
			$aReasons{$i}:=$aReasons{$i}+"Obsolete "
		End if 
		
		If (Position:C15("Never"; [Finished_Goods:26]Status:14)>0)
			$aReasons{$i}:=$aReasons{$i}+"Not Ordered "
		End if 
		
		If ((<>aQty_CC{$i}-<>aQty_EX{$i})>=0)
			$aReasons{$i}:=$aReasons{$i}+"OverRun "
		End if 
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=(Substring:C12(<>aFGKey{$i}; 1; 5)); *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]ProductCode:5=$cpn; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Qty_Open:11>0; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9="C@")
		$underShipped:=0
		$canceled:=0
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($j; 1; Records in selection:C76([Customers_Order_Lines:41]))
				If ([Customers_Order_Lines:41]Status:9="Closed")
					$underShipped:=$underShipped+[Customers_Order_Lines:41]Qty_Open:11
				Else 
					$canceled:=$canceled+[Customers_Order_Lines:41]Qty_Open:11
				End if 
				NEXT RECORD:C51([Customers_Order_Lines:41])
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_Status; 0)
			ARRAY LONGINT:C221($_Qty_Open; 0)
			
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Qty_Open:11; $_Qty_Open; [Customers_Order_Lines:41]Status:9; $_Status)
			
			For ($j; 1; Size of array:C274($_Qty_Open); 1)
				If ($_Status{$j}="Closed")
					$underShipped:=$underShipped+$_Qty_Open{$j}
				Else 
					$canceled:=$canceled+$_Qty_Open{$j}
				End if 
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
		If ($underShipped>0)
			$aReasons{$i}:=$aReasons{$i}+"Closed Short "
		End if 
		
		If ($canceled>0)
			$aReasons{$i}:=$aReasons{$i}+"Cancellation "
		End if 
		
		QUERY:C277([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]OldProductCode:9=$cpn)
		$qtyReduction:=0
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			For ($j; 1; Records in selection:C76([Customers_Order_Changed_Items:176]))
				If ([Customers_Order_Changed_Items:176]NewQty:4<[Customers_Order_Changed_Items:176]OldQty:2)
					$qtyReduction:=[Customers_Order_Changed_Items:176]OldQty:2-[Customers_Order_Changed_Items:176]NewQty:4
				End if 
				NEXT RECORD:C51([Customers_Order_Changed_Items:176])
			End for 
			
		Else 
			
			ARRAY REAL:C219($_NewQty; 0)
			ARRAY REAL:C219($_OldQty; 0)
			
			SELECTION TO ARRAY:C260([Customers_Order_Changed_Items:176]NewQty:4; $_NewQty; [Customers_Order_Changed_Items:176]OldQty:2; $_OldQty)
			
			For ($j; 1; Size of array:C274($_NewQty); 1)
				If ($_NewQty{$j}<$_OldQty{$j})
					$qtyReduction:=$_OldQty{$j}-$_NewQty{$j}
				End if 
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
		
		If ($qtyReduction>0)
			$aReasons{$i}:=$aReasons{$i}+"Change Order "
		End if 
		
	End if   //excess  
	uThermoUpdate($i)
End for 
uThermoClose

//$docRef:=Create document("ELC_ExcessReport"+fYYMMDD (4D_Current_date))
docName:="ELC_ExcessReport"+fYYMMDD(4D_Current_date)
$docRef:=util_putFileName(->docName)
If ($docRef#?00:00:00?)
	uThermoInit($binCursor; "Estee Lauder Saving Report")
	xTitle:="ELC Excess Report as of "+String:C10(4D_Current_date; System date short:K1:1)
	SEND PACKET:C103($docRef; xTitle+$cr+$cr)
	xText:="Product Code"+$t+"Line"+$t+"Excess"+$t+"OverProduction"+$t+"Reason"+$t+"Liability"+$t+"Action Taken"+$cr
	
	For ($i; 1; $binCursor)
		If (Length:C16(xText)>28000)
			SEND PACKET:C103($docRef; xText)
			xText:=""
		End if 
		If (<>aQty_EX{$i}>0)
			xText:=xText+Substring:C12(<>aFGKey{$i}; 7)+$t+$aLine{$i}+$t+String:C10(<>aQty_EX{$i})+$t+String:C10(<>aQty_CC{$i})+$t+$aReasons{$i}+$cr
		End if 
		uThermoUpdate($i)
	End for 
	SEND PACKET:C103($docRef; xText)
	uThermoClose
	
	CLOSE DOCUMENT:C267($docRef)
	BEEP:C151
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	$err:=util_Launch_External_App(docName)
End if 

xText:=""
xTitle:=""