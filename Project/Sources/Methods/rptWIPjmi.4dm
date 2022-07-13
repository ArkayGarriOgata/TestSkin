//%attributes = {"publishedWeb":true}
//Procedure: rptWIPjmi($jobForm;»resultArray)  091098  MLB
//get the JobMakesItem info
//•091198  MLB  fix sort
// Modified by: MelvinBohince (4/6/22) chg to csv

C_TEXT:C284($t; $cr)
ARRAY REAL:C219($2->; 0)
ARRAY REAL:C219($2->; 1)
ARRAY LONGINT:C221($aQtyWant; 0)  //keep this
ARRAY REAL:C219(aStdCost; 0)  //keep this
ARRAY TEXT:C222($aJF; 0)
ARRAY LONGINT:C221($aItem; 0)
ARRAY TEXT:C222(aJobIt; 0)  //keep this
ARRAY TEXT:C222($aCPN; 0)
ARRAY LONGINT:C221($aQtyAct; 0)
ARRAY DATE:C224($aGlued; 0)
ARRAY TEXT:C222($aOrdLine; 0)
ARRAY TEXT:C222($aCustId; 0)

$t:=","  ///Char(9)
$cr:=Char:C90(13)

READ ONLY:C145([Job_Forms_Items:44])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Finished_Goods:26])

//*Get the MTs, IT, and FGs for the job
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$1)

$HPV:=0
SELECTION TO ARRAY:C260([Job_Forms_Items:44]Qty_Want:24; $aQtyWant; [Job_Forms_Items:44]PldCostTotal:21; aStdCost; [Job_Forms_Items:44]JobForm:1; $aJF; [Job_Forms_Items:44]ItemNumber:7; $aItem; [Job_Forms_Items:44]ProductCode:3; $aCPN; [Job_Forms_Items:44]Qty_Actual:11; $aQtyAct; [Job_Forms_Items:44]Glued:33; $aGlued; [Job_Forms_Items:44]OrderItem:2; $aOrdLine; [Job_Forms_Items:44]CustId:15; $aCustId)
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
SORT ARRAY:C229($aItem; $aCPN; $aQtyWant; aStdCost; $aJF; $aQtyAct; $aGlued; $aOrdLine; $aCustId; >)  //•091198  MLB  
ARRAY TEXT:C222(aJobIt; Size of array:C274($aQtyWant))

For ($k; 1; Size of array:C274($aQtyWant))
	$HPV:=$HPV+($aQtyWant{$k}/1000*aStdCost{$k})
	aJobIt{$k}:=$aJF{$k}+"."+String:C10($aItem{$k}; "00")
	If (prnCostCard)
		rCostCardAppend(String:C10($aItem{$k}; "00")+$t+$aCPN{$k}+$t+txt_quote(String:C10($aQtyWant{$k}; "###,###,###"))+$t+txt_quote(String:C10($aQtyAct{$k}; "###,###,###"))+$t+String:C10($aGlued{$k}; <>MIDDATE)+$t+txt_quote(String:C10(aStdCost{$k}; "$###,##0.00"))+$t+txt_quote(String:C10(Round:C94(($aQtyWant{$k}/1000*aStdCost{$k}); 0); "$#,###,###"))+$t)
		
		$wantQtyM:=$aQtyWant{$k}/1000
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$aOrdLine{$k})
		If (Records in selection:C76([Customers_Order_Lines:41])=1)
			$unitPrice:=[Customers_Order_Lines:41]Price_Per_M:8
			$unitCost:=[Customers_Order_Lines:41]Cost_Per_M:7
			$ordQty:=[Customers_Order_Lines:41]Quantity:6
			$salesVal:=[Customers_Order_Lines:41]Price_Per_M:8*$wantQtyM
			$contrib:=Round:C94(($unitPrice*$wantQtyM)-(aStdCost{$k}*$wantQtyM); 0)
			$jobPV:=fProfitVariable("PV"; (aStdCost{$k}*$wantQtyM); ($unitPrice*$wantQtyM); 0)
			$bkdPV:=fProfitVariable("PV"; ($unitCost*($ordQty/1000)); ($unitPrice*($ordQty/1000)); 0)
			If ($ordQty>$aQtyWant{$k})  //cant sell what you aint got
				$actContri:=Round:C94(($unitPrice*$wantQtyM)-(aStdCost{$k}*($wantQtyM)); 0)
				$actPV:=fProfitVariable("PV"; (aStdCost{$k}*$wantQtyM); ($unitPrice*$wantQtyM); 0)
			Else 
				$actContri:=Round:C94(($unitPrice*($ordQty/1000))-(aStdCost{$k}*$wantQtyM); 0)
				$actPV:=fProfitVariable("PV"; (aStdCost{$k}*$wantQtyM); ($unitPrice*($ordQty/1000)); 0)
			End if 
			
		Else 
			qryFinishedGood($aCustId{$k}; $aCPN{$k})
			If (Records in selection:C76([Finished_Goods:26])>0)
				If ([Finished_Goods:26]RKContractPrice:49#0)
					$unitPrice:=[Finished_Goods:26]RKContractPrice:49
				Else 
					$unitPrice:=FG_getLastPrice($aCustId{$k}+":"+$aCPN{$k})  // • mel (6/29/05, 10:48:19) don't depend on Lastprice field
				End if 
				
				$unitCost:=0
				$ordQty:=0
				$salesVal:=$unitPrice*$wantQtyM
				$contrib:=Round:C94(($unitPrice*$wantQtyM)-(aStdCost{$k}*$wantQtyM); 0)
				$jobPV:=fProfitVariable("PV"; (aStdCost{$k}*$wantQtyM); ($unitPrice*$wantQtyM); 0)  //083198
				$bkdPV:=0
				$actPV:=0
				$actContri:=0
				
			Else 
				$unitPrice:=0
				$unitCost:=0
				$ordQty:=0
				$salesVal:=$unitPrice*$wantQtyM
				$contrib:=Round:C94(($unitPrice*$wantQtyM)-(aStdCost{$k}*$wantQtyM); 0)
				$jobPV:=fProfitVariable("PV"; (aStdCost{$k}*$wantQtyM); ($unitPrice*$wantQtyM); 0)  //083198
				$bkdPV:=0
				$actPV:=0
				$actContri:=0
			End if   //recs in fg
		End if   //ord line
		rCostCardAppend($aOrdLine{$k}+$t+txt_quote(String:C10($unitPrice; "$##,##0.00"))+$t+txt_quote(String:C10($unitCost; "$##,##0.00"))+$t+txt_quote(String:C10($ordQty; "###,###,##0"))+$t)
		rCostCardAppend(String:C10(Round:C94($salesVal; 0))+$t+String:C10($contrib)+$t+txt_quote(String:C10(Round:C94($jobPV; 2); "##,##0.00"))+$t+txt_quote(String:C10(Round:C94($bkdPV; 2); "##,##0.00"))+$t+txt_quote(String:C10(Round:C94($actPV; 2); "##,##0.00"))+$t+String:C10($actContri)+$cr)
	End if   //cost card
End for 
If (prnCostCard)
	$totalRow:=Size of array:C274($aQtyWant)+6
	rCostCardAppend(($t*11)+"=SUM(L7:L"+String:C10($totalRow)+")"+$t+"=SUM(M7:M"+String:C10($totalRow)+")"+$t+"=M"+String:C10($totalRow+1)+"/L"+String:C10($totalRow+1)+$cr)
	
End if 
$2->{1}:=$HPV

ARRAY LONGINT:C221($aQtyAct; 0)
ARRAY DATE:C224($aGlued; 0)
ARRAY TEXT:C222($aOrdLine; 0)
ARRAY TEXT:C222($aCustId; 0)