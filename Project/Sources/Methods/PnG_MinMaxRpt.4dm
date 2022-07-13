//%attributes = {"publishedWeb":true}
// Method: PnG_MinMaxRpt () -> 
// ----------------------------------------------------
// was Method: rProctorAndGamble2 () -> 
// ----------------------------------------------------
// was`rProctorAndGamble2
//081000 mlb
//change to approved format that was done manually

C_TEXT:C284($t; $cr)
C_LONGINT:C283($numOL; $order; $row; $buffer; $numFG)
C_TEXT:C284($lastCPN; $lastOL; $custid)

$t:=Char:C90(9)
$cr:=Char:C90(13)
$buffer:=100
ARRAY TEXT:C222($aLine; $buffer)  //buffer

$row:=0
$custid:="00199"
MESSAGES OFF:C175
zwStatusMsg("P&G Rpt"; "Gathering data...")

$numOL:=qryOpenOrdLines("*")
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$custid)
$numOL:=Records in selection:C76([Customers_Order_Lines:41])
If ($numOL>0)
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $aOL; [Customers_Order_Lines:41]ProductCode:5; $aCPN; [Customers_Order_Lines:41]PONumber:21; $aPO)
	ARRAY TEXT:C222($aSortKey; $numOL)
	For ($order; 1; $numOL)
		$aSortKey{$order}:=$aCPN{$order}+$aOL{$order}
	End for 
	SORT ARRAY:C229($aSortKey; $aOL; $aCPN; $aPO; >)
	ARRAY TEXT:C222($aSortKey; 0)
	
	$row:=1
	$aLine{$row}:="PO Nº"+$t+"Product Code"+$t+"Description"+$t+"Min"+$t+"Max"+$t+"WIP"+$t+"Pjt Avail"+$t+"Shipped"+$t+"Warehoused"+$t+"Released"+$t+"Removed"+$t+"Balance"+$t+"Direct"+$t+"Release Nº"+$t+"Over 90"
	
	$lastCPN:=""
	$lastOL:=""
	$totalPayUse:=0
	$totalRemoved:=0
	$totalBalance:=0
	$totalDirect:=0
	For ($order; 1; $numOL)
		If ($lastCPN#$aCPN{$order})
			//total out prior FG
			If ($row#1)
				//$row:=$row+1
				$aLine{$row}:=""+$t+"T O T A L S:"+$t+""+""+$t+$min+$t+$max+$t+$wip+$t+""+$t+""+$t+String:C10($totalPayUse)+$t+""+$t+String:C10($totalRemoved)+$t+String:C10($totalBalance)+$t+String:C10($totalDirect)+$t+""+$t+""
			End if 
			//prepare for next FG      
			$row:=$row+2
			If ($row>Size of array:C274($aLine))
				ARRAY TEXT:C222($aLine; $row+$buffer)  //buffer
			End if 
			
			$totalRemoved:=0
			$totalBalance:=0
			$totalDirect:=0
			$totalPayUse:=0
			$numFG:=qryFinishedGood($custid; $aCPN{$order})
			$desc:=[Finished_Goods:26]CartonDesc:3
			$min:=String:C10([Finished_Goods:26]InventoryMin:62)
			$max:=String:C10([Finished_Goods:26]InventoryMax:63)
			$numJMI:=qryJMI("@"; 0; $aCPN{$order})
			QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Actual:11=0)
			$wip:=String:C10(Sum:C1([Job_Forms_Items:44]Qty_Yield:9))
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$aCPN{$order}; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG:AV@")
			$totalBalance:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
			
			$aLine{$row}:=$aPO{$order}+$t+$aCPN{$order}+$t+$desc+$t+""+$t+""+$t+""+$t+""+$t
		End if 
		$lastCPN:=$aCPN{$order}
		
		If ($lastOL#$aOL{$order})  //get the releases      
			QUERY:C277([Customers_BilledPayUse:86]; [Customers_BilledPayUse:86]Orderline:1=$aOL{$order})
			$totalRemoved:=$totalRemoved+Sum:C1([Customers_BilledPayUse:86]QuantityBilled:6)
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=$aOL{$order})
			$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
			ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
			
			$aLine{$row}:=$aLine{$row}+String:C10([Customers_ReleaseSchedules:46]Actual_Date:7; System date short:K1:1)+$t
			If ([Customers_ReleaseSchedules:46]PayU:31=1)
				$aLine{$row}:=$aLine{$row}+String:C10([Customers_ReleaseSchedules:46]Actual_Qty:8)+$t
				$totalPayUse:=$totalPayUse+[Customers_ReleaseSchedules:46]Actual_Qty:8
			Else 
				$aLine{$row}:=$aLine{$row}+"0"+$t
			End if 
			$aLine{$row}:=$aLine{$row}+String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)+$t
			
			If ([Customers_ReleaseSchedules:46]PayU:31=1)
				//can't get balance as below:        
				//$lookFor:="FG:AV"+fGetAvonBin ([ReleaseSchedule]Shipto)
				//+"#"+[ReleaseSchedule]CustomerRefer
				//QUERY([FG_Locations];[FG_Locations]Location=$lookFor)
				//$balance:=Sum([FG_Locations]QtyOH)
				//$removed:=[ReleaseSchedule]Actual_Qty-$balance
				//QUERY([BilledPayUse];[BilledPayUse]PONumber=(Substring([ReleaseSchedule]Customer
				$removed:=0  //Sum([BilledPayUse]QuantityBilled)
				$balance:=0  //[ReleaseSchedule]Actual_Qty-$removed
				$aLine{$row}:=$aLine{$row}+String:C10($removed)+$t+String:C10($balance)+$t+"0"+$t
			Else 
				$aLine{$row}:=$aLine{$row}+"0"+$t+"0"+$t+String:C10([Customers_ReleaseSchedules:46]Actual_Qty:8)+$t
				$totalDirect:=$totalDirect+[Customers_ReleaseSchedules:46]Actual_Qty:8
			End if 
			$aLine{$row}:=$aLine{$row}+[Customers_ReleaseSchedules:46]CustomerRefer:3+$t+""
			
			NEXT RECORD:C51([Customers_ReleaseSchedules:46])
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
				
				For ($rel; 2; $numRels)
					$row:=$row+1
					If ($row>Size of array:C274($aLine))
						ARRAY TEXT:C222($aLine; $row+$buffer)  //buffer
					End if 
					$aLine{$row}:=""+$t+""+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t
					$aLine{$row}:=$aLine{$row}+String:C10([Customers_ReleaseSchedules:46]Actual_Date:7; System date short:K1:1)+$t
					If ([Customers_ReleaseSchedules:46]PayU:31=1)
						$aLine{$row}:=$aLine{$row}+String:C10([Customers_ReleaseSchedules:46]Actual_Qty:8)+$t
						$totalPayUse:=$totalPayUse+[Customers_ReleaseSchedules:46]Actual_Qty:8
					Else 
						$aLine{$row}:=$aLine{$row}+"0"+$t
					End if 
					$aLine{$row}:=$aLine{$row}+String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)+$t
					
					If ([Customers_ReleaseSchedules:46]PayU:31=1)
						//can't get balance as below:        
						//$lookFor:="FG:AV"+fGetAvonBin ([ReleaseSchedule]Shipto)
						//+"#"+[ReleaseSchedule]CustomerRefer
						//QUERY([FG_Locations];[FG_Locations]Location=$lookFor)
						//$balance:=Sum([FG_Locations]QtyOH)
						//$removed:=[ReleaseSchedule]Actual_Qty-$balance
						//QUERY([BilledPayUse];[BilledPayUse]PONumber=(Substring([ReleaseSchedule]Customer
						$removed:=0  //Sum([BilledPayUse]QuantityBilled)
						$balance:=0  //[ReleaseSchedule]Actual_Qty-$removed
						$aLine{$row}:=$aLine{$row}+String:C10($removed)+$t+String:C10($balance)+$t+"0"+$t
					Else 
						$aLine{$row}:=$aLine{$row}+"0"+$t+"0"+$t+String:C10([Customers_ReleaseSchedules:46]Actual_Qty:8)+$t
						$totalDirect:=$totalDirect+[Customers_ReleaseSchedules:46]Actual_Qty:8
					End if 
					$aLine{$row}:=$aLine{$row}+[Customers_ReleaseSchedules:46]CustomerRefer:3+$t+""
					
					NEXT RECORD:C51([Customers_ReleaseSchedules:46])
				End for   //rels
				
				
			Else 
				
				ARRAY DATE:C224($_Actual_Date; 0)
				ARRAY INTEGER:C220($_PayU; 0)
				ARRAY LONGINT:C221($_Actual_Qty; 0)
				ARRAY DATE:C224($_Sched_Date; 0)
				ARRAY TEXT:C222($_CustomerRefer; 0)
				
				SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Actual_Date:7; $_Actual_Date; \
					[Customers_ReleaseSchedules:46]PayU:31; $_PayU; \
					[Customers_ReleaseSchedules:46]Actual_Qty:8; $_Actual_Qty; \
					[Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date; \
					[Customers_ReleaseSchedules:46]CustomerRefer:3; $_CustomerRefer)
				
				For ($rel; 2; $numRels; 1)
					$row:=$row+1
					If ($row>Size of array:C274($aLine))
						ARRAY TEXT:C222($aLine; $row+$buffer)  //buffer
					End if 
					$aLine{$row}:="\t"*7  //""+$t+""+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t
					$aLine{$row}:=$aLine{$row}+String:C10($_Actual_Date{$rel}; System date short:K1:1)+"\t"
					If ($_PayU{$rel}=1)
						$aLine{$row}:=$aLine{$row}+String:C10($_Actual_Qty{$rel})+"\t"
						$totalPayUse:=$totalPayUse+$_Actual_Qty{$rel}
					Else 
						$aLine{$row}:=$aLine{$row}+"0\t"
					End if 
					$aLine{$row}:=$aLine{$row}+String:C10($_Sched_Date{$rel}; System date short:K1:1)+"\t"
					
					If ($_PayU{$rel}=1)
						$removed:=0  //Sum([BilledPayUse]QuantityBilled)
						$balance:=0  //[ReleaseSchedule]Actual_Qty-$removed
						$aLine{$row}:=$aLine{$row}+String:C10($removed)+"\t"+String:C10($balance)+"\t0\t"
					Else 
						$aLine{$row}:=$aLine{$row}+"0\t0\t"+String:C10($_Actual_Qty{$rel})+"\t"
						$totalDirect:=$totalDirect+$_Actual_Qty{$rel}
					End if 
					$aLine{$row}:=$aLine{$row}+$_CustomerRefer{$rel}+"\t"
					
				End for   //rels
				
				
			End if   // END 4D Professional Services : January 2019 
			$row:=$row+1
			If ($row>Size of array:C274($aLine))
				ARRAY TEXT:C222($aLine; $row+$buffer)  //buffer
			End if 
			$aLine{$row}:=""+$t+""+""+$t+""+$t+""+$t+""+$t+""+$t+""+$t
		End if 
		$lastOL:=$aOL{$order}
		
	End for 
	
	zwStatusMsg("P&G Rpt"; "Saving to filename: PnG_MinMax.txt")
	C_TEXT:C284(xTitle; xText; docName)
	xTitle:="P&G Inventory Position "+TS2String(TSTimeStamp)
	xText:=""
	For ($i; 1; $row)
		xText:=xText+$aLine{$i}+$cr
	End for 
	C_TIME:C306($docRef)
	docName:="PnG_MinMax.txt"
	$docRef:=util_putFileName(->docName)
	If ($docRef#?00:00:00?)
		SEND PACKET:C103($docRef; xTitle+Char:C90(13)+Char:C90(13))
		SEND PACKET:C103($docRef; xText)
		SEND PACKET:C103($docRef; Char:C90(13)+Char:C90(13)+"------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)  //
		$err:=util_Launch_External_App(docName)
	End if 
End if   //num ol>0  