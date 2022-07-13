//%attributes = {"publishedWeb":true}
//Procedure: rptWIPmachHrs(jobform;»array)  091098  MLB
//get the machine hours for a job
//•091198  MLB  add item, fix sort
//•121598  Systems G3  UPR mke date sensitive
//•051799  mlb  chg BB from <=beginDate to <beginDate
// • mel (5/11/05, 12:43:19) don't dup StdMR in listing
// • mel (6/23/05, 16:11:59) chg to planned value, not flexed
// Modified by: MelvinBohince (4/4/22) add $description for CostCtrCurrent's 3rd param
// Modified by: MelvinBohince (4/6/22) chg to CSV

C_TEXT:C284($1)  //jobform
C_TEXT:C284($t; $cr; $description)
C_DATE:C307($3)  //end date optional`•121598  Systems G3  UPR mke date sensitive
C_LONGINT:C283($machTic; $budSeq; $numMachineTickets; $hit)
C_BOOLEAN:C305($sequenceTitleRow; $noMachineTickets)
ARRAY REAL:C219($2->; 0)
ARRAY REAL:C219($2->; 6)
ARRAY DATE:C224($aDate; 0)
ARRAY REAL:C219($aMR; 0)
ARRAY REAL:C219($aRun; 0)
ARRAY TEXT:C222($aCC; 0)
ARRAY INTEGER:C220($aSeq; 0)
ARRAY INTEGER:C220($aUsed; 0)
ARRAY LONGINT:C221($aGood; 0)
ARRAY LONGINT:C221($aWaste; 0)
ARRAY INTEGER:C220($aMTitem; 0)  //•091198  MLB 

$t:=","  ///Char(9)
$cr:=Char:C90(13)
If (prnCostCard)
	rCostCardAppend(rCostCardHdrs(3))
End if 

READ ONLY:C145([Job_Forms_Machine_Tickets:61])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=$1)
	If (Count parameters:C259>2)  //•121598  Systems G3  UPR mke date sensitive
		If ($3#!00-00-00!)
			QUERY SELECTION:C341([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5<=$3)
		End if 
	End if 
	
Else 
	
	
	If (Count parameters:C259>2)  //•121598  Systems G3  UPR mke date sensitive
		If ($3#!00-00-00!)
			QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5<=$3; *)
		End if 
	End if 
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=$1)
End if   // END 4D Professional Services : January 2019 query selection


SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]DateEntered:5; $aDate; [Job_Forms_Machine_Tickets:61]MR_Act:6; $aMR; [Job_Forms_Machine_Tickets:61]Run_Act:7; $aRun; [Job_Forms_Machine_Tickets:61]CostCenterID:2; $aCC; [Job_Forms_Machine_Tickets:61]Sequence:3; $aSeq; [Job_Forms_Machine_Tickets:61]Good_Units:8; $aGood; [Job_Forms_Machine_Tickets:61]Waste_Units:9; $aWaste; [Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; $aMTitem)
REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
$numMachineTickets:=Size of array:C274($aDate)
SORT ARRAY:C229($aDate; $aMR; $aRun; $aCC; $aSeq; $aGood; $aWaste; $aMTitem; >)
If ($numMachineTickets>0)
	firstMach:=$aDate{1}
End if 
ARRAY INTEGER:C220($aUsed; $numMachineTickets)  //mark if this has been printed on CostCrd
$beginBal:=0
$labor:=0
$burden:=0
$lastSeq:=0
$cclabor:=0
$ccburden:=0

//determine the begininng and current wip balance
For ($machTic; 1; $numMachineTickets)
	$hrs:=$aMR{$machTic}+$aRun{$machTic}
	If ($aDate{$machTic}<beginDate)
		$beginBal:=$beginBal+($hrs*CostCtrCurrent("OOP"; $aCC{$machTic}))
	Else 
		$labor:=$labor+($hrs*CostCtrCurrent("Labor"; $aCC{$machTic}))
		$burden:=$burden+($hrs*CostCtrCurrent("Burden"; $aCC{$machTic}))
	End if 
	If ($lastSeq<$aSeq{$machTic})
		$lastSeq:=$aSeq{$machTic}
	End if 
End for 

If (prnCostCard)
	ARRAY INTEGER:C220($aPldSeq; 0)
	ARRAY TEXT:C222($aPldCC; 0)
	ARRAY REAL:C219($aPldMR; 0)
	ARRAY REAL:C219($aPldRate; 0)
	ARRAY REAL:C219($aPldRun; 0)
	READ ONLY:C145([Job_Forms_Machines:43])
	QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$1; *)
	QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]CostCenterID:4#"!@")
	SELECTION TO ARRAY:C260([Job_Forms_Machines:43]Sequence:5; $aPldSeq; [Job_Forms_Machines:43]CostCenterID:4; $aPldCC; [Job_Forms_Machines:43]Planned_MR_Hrs:15; $aPldMR; [Job_Forms_Machines:43]Planned_RunRate:36; $aPldRate; [Job_Forms_Machines:43]Planned_RunHrs:37; $aPldRun)
	REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
	SORT ARRAY:C229($aPldSeq; $aPldCC; $aPldMR; $aPldRate; $aPldRun)
	$numBudgetSequences:=Size of array:C274($aPldSeq)
	$totActMR:=0
	$totActRun:=0
	$totStdMR:=0
	$totStdRun:=0
	$totQty:=0
	$totActCost:=0
	$totStdCost:=0
	For ($budSeq; 1; $numBudgetSequences)  //for each budgeted sequence, report it and gather its machinetickets
		$totSeqStdMR:=0
		$totSeqActMR:=0
		$totSeqStdRun:=0
		$totSeqActRun:=0
		$totSeqQty:=0
		$totSeqActCost:=0
		$totSeqStdCost:=0
		//$hit:=$aPldCC{$budSeq}
		$description:=""
		$stdOOP:=CostCtrCurrent("OOP"; $aPldCC{$budSeq}; ->$description)  // Modified by: MelvinBohince (4/4/22) 
		rCostCardAppend(String:C10($aPldSeq{$budSeq}; "000")+" - "+$aPldCC{$budSeq}+$t+$description+$t+txt_quote(String:C10($aPldMR{$budSeq}; "#,##0.00"))+"/"+String:C10($aPldRate{$budSeq})+$t+txt_quote(String:C10($stdOOP; "###.00")+$t))  //aCostCtrDes{$hit}
		
		$sequenceTitleRow:=True:C214
		$noMachineTickets:=True:C214
		//look for machine tickets recorded against this sequence
		For ($machTic; 1; $numMachineTickets)
			If ($aSeq{$machTic}=$aPldSeq{$budSeq})  //($aCC{$j}=$aPldCC{$k}) &
				$noMachineTickets:=False:C215
				$hrs:=$aMR{$machTic}+$aRun{$machTic}
				$cclabor:=$cclabor+($hrs*CostCtrCurrent("Labor"; $aCC{$machTic}))
				$ccburden:=$ccburden+($hrs*CostCtrCurrent("Burden"; $aCC{$machTic}))
				$aUsed{$machTic}:=1  //mark it
				If (Not:C34($sequenceTitleRow))
					rCostCardAppend($t+$t+$t+$t)
					$stdMR:=0
					$stdRun:=0  // • mel (6/23/05, 16:11:59) chg to planned value, not flexed
				Else   //only print the mr once
					$stdMR:=$aPldMR{$budSeq}
					$stdRun:=$aPldRun{$budSeq}  // • mel (6/23/05, 16:11:59) chg to planned value, not flexed
				End if 
				// • mel (6/23/05, 16:11:59) chg to planned value, not flexed (below commented out
				//If ($aPldRate{$k}>0)
				//$stdRun:=Round(($aGood{$j}+$aWaste{$j})/$aPldRate{$k};2)  `
				//Else 
				//$stdRun:=0
				//End if 
				$actOOP:=CostCtrCurrent("OOP"; $aCC{$machTic})
				If ($aCC{$machTic}#$aPldCC{$budSeq})
					$unBudFlag:="-"
				Else 
					$unBudFlag:=""
				End if 
				rCostCardAppend($unBudFlag+$aCC{$machTic}+$t+String:C10($actOOP; "###.00")+$t+String:C10($aDate{$machTic}; <>MIDDATE)+$t+String:C10($aMR{$machTic})+$t+String:C10($aRun{$machTic})+$t+txt_quote(String:C10($stdMR; "#,##0.00"))+$t+txt_quote(String:C10($stdRun; "#,##0.00"))+$t+txt_quote(String:C10($aGood{$machTic}+$aWaste{$machTic}; "##,###,###"))+$t+String:C10(Round:C94((($aMR{$machTic}+$aRun{$machTic})*$actOOP); 0))+$t+String:C10(Round:C94((($stdMR+$stdRun)*$stdOOP); 0))+$t+String:C10($aMTitem{$machTic}; "00;-0; ")+$cr)
				$sequenceTitleRow:=False:C215
				
				$totSeqStdMR:=$totSeqStdMR+$stdMR
				$totSeqActMR:=$totSeqActMR+$aMR{$machTic}
				$totSeqStdRun:=$totSeqStdRun+$stdRun
				$totSeqActRun:=$totSeqActRun+$aRun{$machTic}
				$totSeqQty:=$totSeqQty+$aGood{$machTic}+$aWaste{$machTic}
				$totSeqActCost:=$totSeqActCost+(Round:C94((($aMR{$machTic}+$aRun{$machTic})*$actOOP); 0))
				$totSeqStdCost:=$totSeqStdCost+(Round:C94((($stdMR+$stdRun)*$stdOOP); 0))
				
				$totActMR:=$totActMR+$aMR{$machTic}
				$totActRun:=$totActRun+$aRun{$machTic}
				$totStdMR:=$totStdMR+$stdMR
				$totStdRun:=$totStdRun+$stdRun
				$totQty:=$totQty+$aGood{$machTic}+$aWaste{$machTic}
				$totActCost:=$totActCost+(Round:C94((($aMR{$machTic}+$aRun{$machTic})*$actOOP); 0))
				$totStdCost:=$totStdCost+(Round:C94((($stdMR+$stdRun)*$stdOOP); 0))
			End if 
		End for   //matching $machTic's
		
		If ($noMachineTickets)  // • mel (6/29/05, 13:21:18)
			$totStdMR:=$totStdMR+$aPldMR{$budSeq}
			$totStdRun:=$totStdRun+$aPldRun{$budSeq}
			$totStdCost:=$totStdCost+(Round:C94((($aPldMR{$budSeq}+$aPldRun{$budSeq})*$stdOOP); 0))
			rCostCardAppend("-000"+$t+"0"+$t+"N/A"+$t+"0"+$t+"0"+$t+txt_quote(String:C10($aPldMR{$budSeq}; "#,##0.00"))+$t+txt_quote(String:C10($aPldRun{$budSeq}; "#,##0.00"))+$t+"0"+"0"+$t+"0"+$t+String:C10(Round:C94((($aPldMR{$budSeq}+$aPldRun{$budSeq})*$stdOOP); 0))+$t+""+$t+""+$t+"0"+$cr)
		End if 
		
		If ($sequenceTitleRow)  //no actuals were found for this sequence
			rCostCardAppend($cr+$cr)
			
		Else   //subtotals
			rCostCardAppend($t+$t+"SUBTOTAL"+($t*5)+String:C10($totSeqActMR)+$t+String:C10($totSeqActRun)+$t+txt_quote(String:C10($totSeqStdMR; "#,##0.00"))+$t+txt_quote(String:C10($totSeqStdRun; "#,##0.00"))+$t+txt_quote(String:C10($totSeqQty; "##,###,###"))+$t+String:C10(Round:C94($totSeqActCost; 0))+$t+String:C10(Round:C94($totSeqStdCost; 0))+$t+""+$t)
			If ($totSeqActRun#0)
				rCostCardAppend(String:C10(Round:C94($totSeqQty/$totSeqActRun; 0))+$t)
			Else 
				rCostCardAppend("0"+$t)
			End if 
			If ($totSeqStdRun#0)
				rCostCardAppend(String:C10(Round:C94($totSeqQty/$totSeqStdRun; 0))+$cr+$cr)
			Else 
				rCostCardAppend("0"+$cr+$cr)
			End if 
		End if 
		
	End for 
	
	$hit:=Find in array:C230($aUsed; 0)  //look for unused MachineTickets
	If ($hit>-1)  //at least one found
		rCostCardAppend(rCostCardHdrs(4))
		
		For ($machTic; 1; $numMachineTickets)
			If ($aUsed{$machTic}#1)  //not previously totaled
				$hrs:=$aMR{$machTic}+$aRun{$machTic}
				$cclabor:=$cclabor+($hrs*CostCtrCurrent("Labor"; $aCC{$machTic}))
				$ccburden:=$ccburden+($hrs*CostCtrCurrent("Burden"; $aCC{$machTic}))
				$hit:=CostCtrCurrent("Desc"; $aCC{$machTic})
				$actOOP:=CostCtrCurrent("OOP"; $aCC{$machTic})
				rCostCardAppend($t+aCostCtrDes{$hit}+$t+"Seq: "+String:C10($aSeq{$machTic}; "000")+$t+$t+$aCC{$machTic}+$t+String:C10($actOOP; "###.00")+$t+String:C10($aDate{$machTic}; <>MIDDATE)+$t+String:C10($aMR{$machTic})+$t+String:C10($aRun{$machTic})+$t+$t+$t+txt_quote(String:C10($aGood{$machTic}+$aWaste{$machTic}; "##,###,###"))+$t+String:C10(Round:C94(($actOOP*($aMR{$machTic}+$aRun{$machTic})); 0))+$t+"0"+$t+String:C10($aMTitem{$machTic}; "00;-0; ")+$cr)
				
				$totActMR:=$totActMR+$aMR{$machTic}
				$totActRun:=$totActRun+$aRun{$machTic}
				$totQty:=$totQty+$aGood{$machTic}+$aWaste{$machTic}
				$totActCost:=$totActCost+(Round:C94((($aMR{$machTic}+$aRun{$machTic})*$actOOP); 0))
			End if 
		End for 
	End if 
	
	//TOTALS
	rCostCardAppend($t+$t+"TOTAL"+($t*5)+String:C10($totActMR)+$t+String:C10($totActRun)+$t+txt_quote(String:C10($totStdMR; "#,##0.00"))+$t+txt_quote(String:C10($totStdRun; "#,##0.00"))+$t+txt_quote(String:C10($totQty; "##,###,###"))+$t+String:C10(Round:C94($totActCost; 0))+$t+String:C10(Round:C94($totStdCost; 0))+$t+""+$t)
	If ($totActRun#0)
		rCostCardAppend(String:C10(Round:C94($totQty/$totActRun; 0))+$t)
	Else 
		rCostCardAppend("0"+$t)
	End if 
	
	If ($totStdRun#0)
		rCostCardAppend(String:C10(Round:C94($totQty/$totStdRun; 0))+$cr+$cr)
	Else 
		rCostCardAppend("0"+$cr+$cr)
	End if 
	
End if   //prnCostCard

ARRAY REAL:C219($aMR; 0)
ARRAY REAL:C219($aRun; 0)
ARRAY TEXT:C222($aCC; 0)
ARRAY INTEGER:C220($aSeq; 0)
ARRAY INTEGER:C220($aPldSeq; 0)
ARRAY TEXT:C222($aPldCC; 0)
ARRAY REAL:C219($aPldMR; 0)
ARRAY REAL:C219($aPldRate; 0)
ARRAY LONGINT:C221($aGood; 0)
ARRAY LONGINT:C221($aWaste; 0)

$2->{1}:=$beginBal
$2->{2}:=$labor
$2->{3}:=$burden
$2->{4}:=$lastSeq
$2->{5}:=$cclabor
$2->{6}:=$ccburden