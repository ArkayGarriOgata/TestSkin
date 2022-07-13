//%attributes = {"publishedWeb":true}
//uGetActMachData upr 1255 10/26/94
//•080596  MLB  add new method for speed
//•112796    don't double count sequences
//•090297  MLB  this doesne't permit substitute
//• 4/10/98 cs Nan Checking

READ ONLY:C145([Cost_Centers:27])
C_LONGINT:C283($1)
If (Count parameters:C259=0)  //used in applyformula
	READ ONLY:C145([Job_Forms_Machine_Tickets:61])
	qryCostCenter([Job_Forms_Machines:43]CostCenterID:4; [Job_Forms_Machines:43]Effectivity:3)
	
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=[Job_Forms_Machines:43]JobForm:1; *)
	//SEARCH([MachineTicket]; & [MachineTicket]CostCenterID=[Machine_Job
	//«]CostCenterID;*)`•090297  MLB  this doesne't permit substitute
	QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]Sequence:3=[Job_Forms_Machines:43]Sequence:5)
	[Job_Forms_Machines:43]Actual_Qty:19:=Sum:C1([Job_Forms_Machine_Tickets:61]Good_Units:8)
	[Job_Forms_Machines:43]Actual_Waste:20:=Sum:C1([Job_Forms_Machine_Tickets:61]Waste_Units:9)
	[Job_Forms_Machines:43]Actual_RunHrs:40:=Sum:C1([Job_Forms_Machine_Tickets:61]Run_Act:7)
	[Job_Forms_Machines:43]Actual_MR_Hrs:24:=Sum:C1([Job_Forms_Machine_Tickets:61]MR_Act:6)
	$totalHrs:=[Job_Forms_Machines:43]Actual_RunHrs:40+[Job_Forms_Machines:43]Actual_MR_Hrs:24
	[Job_Forms_Machines:43]Actual_Labor:22:=[Cost_Centers:27]MHRlaborSales:4*$totalHrs
	[Job_Forms_Machines:43]Actual_OH:23:=[Cost_Centers:27]MHRburdenSales:5*$totalHrs
	[Job_Forms_Machines:43]Actual_SE_Cost:25:=[Cost_Centers:27]ScrapExcessCost:32*$totalHrs
	[Job_Forms_Machines:43]Actual_RunRate:39:=uNANCheck(([Job_Forms_Machines:43]Actual_Qty:19+[Job_Forms_Machines:43]Actual_Waste:20)/[Job_Forms_Machines:43]Actual_RunHrs:40)
	//If (Position([Machine_Job]CostCenterID;◊SHEETERS)>0)  `convert to lf
	//[Machine_Job]Actual_RunRate:=[Machine_Job]Actual_RunRate*([JobForm]Lenth/12)
	//End if 
	
Else   //used in jobform input onload   •080596  MLB 
	C_LONGINT:C283($hit; $i; $act; $waste)
	C_REAL:C285($run; $mr)
	ARRAY INTEGER:C220($aSeq; 0)
	ARRAY LONGINT:C221($aGood; 0)
	ARRAY LONGINT:C221($aWaste; 0)
	ARRAY REAL:C219($aRun; 0)
	ARRAY REAL:C219($aMR; 0)
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
		SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]Sequence:3; $aSeq; [Job_Forms_Machine_Tickets:61]Good_Units:8; $aGood; [Job_Forms_Machine_Tickets:61]Waste_Units:9; $aWaste; [Job_Forms_Machine_Tickets:61]Run_Act:7; $aRun; [Job_Forms_Machine_Tickets:61]MR_Act:6; $aMR)
		SORT ARRAY:C229($aSeq; $aGood; $aWaste; $aRun; $aMR; >)
		
		ARRAY BOOLEAN:C223($aUsed; Size of array:C274($aSeq))  //•112796  
		
		FIRST RECORD:C50([Job_Forms_Machines:43])
		For ($i; 1; Records in selection:C76([Job_Forms_Machines:43]))
			$act:=0
			$waste:=0
			$run:=0
			$mr:=0
			$hit:=Find in array:C230($aSeq; [Job_Forms_Machines:43]Sequence:5)
			While ($hit#-1)
				If (Not:C34($aUsed{$hit}))
					$aUsed{$hit}:=True:C214  //•112796   
					$act:=$act+$aGood{$hit}
					$waste:=$waste+$aWaste{$hit}
					$run:=$run+$aRun{$hit}
					$mr:=$mr+$aMR{$hit}
				End if 
				$hit:=Find in array:C230($aSeq; [Job_Forms_Machines:43]Sequence:5; ($hit+1))
			End while 
			[Job_Forms_Machines:43]Actual_Qty:19:=$act
			[Job_Forms_Machines:43]Actual_Waste:20:=$waste
			[Job_Forms_Machines:43]Actual_RunHrs:40:=$run
			[Job_Forms_Machines:43]Actual_MR_Hrs:24:=$mr
			If ($run>0) | ($mr>0)
				qryCostCenter([Job_Forms_Machines:43]CostCenterID:4)  //;[Machine_Job]Effectivity)
				[Job_Forms_Machines:43]Actual_Labor:22:=[Cost_Centers:27]MHRlaborSales:4*($run+$mr)
				[Job_Forms_Machines:43]Actual_OH:23:=[Cost_Centers:27]MHRburdenSales:5*($run+$mr)
				[Job_Forms_Machines:43]Actual_SE_Cost:25:=[Cost_Centers:27]ScrapExcessCost:32*($run+$mr)
				If ($run#0)
					[Job_Forms_Machines:43]Actual_RunRate:39:=uNANCheck(($act+$waste)/$run)
				Else 
					[Job_Forms_Machines:43]Actual_RunRate:39:=0
				End if 
			End if 
			SAVE RECORD:C53([Job_Forms_Machines:43])
			NEXT RECORD:C51([Job_Forms_Machines:43])
		End for 
		
	End if   //machine tickets
	
End if   //parameter

//