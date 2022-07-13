//%attributes = {}
//job_ProdAnalCCRptDetail

rSheets:=[Job_Forms_Machine_Tickets:61]Good_Units:8
rAct_MR:=[Job_Forms_Machine_Tickets:61]MR_Act:6
If ([Job_Forms_Machine_Tickets:61]MR_AdjStd:14#0)  //•120998  MLB  
	rStd_MR:=[Job_Forms_Machine_Tickets:61]MR_AdjStd:14
Else 
	//mlb 08/12/03 use cache
	C_LONGINT:C283($hit)
	//$hit:=Find in array(aJobSeq;([MachineTicket]JobForm+String([MachineTicket]Sequence;"000")))
	
	$hit:=Find in array:C230(aMJsequence; ([Job_Forms_Machine_Tickets:61]JobForm:1+String:C10([Job_Forms_Machine_Tickets:61]Sequence:3; "000")))
	If ($hit>-1)
		rStd_MR:=aMJmrHrs{$hit}
		
	Else 
		rStd_MR:=0
	End if 
End if 

rAct_Run:=[Job_Forms_Machine_Tickets:61]Run_Act:7
rStd_Run:=[Job_Forms_Machine_Tickets:61]Run_AdjStd:15
rAct_Tot:=[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
rStd_Tot:=rStd_MR+[Job_Forms_Machine_Tickets:61]Run_AdjStd:15  //[MachineTicket]MR_AdjStd  `•121898  Systems G3  

If (([Job_Forms_Machine_Tickets:61]DateEntered:5=dPrevDate) & ([Job_Forms_Machine_Tickets:61]CostCenterID:2=aPrevCC))
	//rDown_Hrs:=0
	
Else 
	dPrevDate:=[Job_Forms_Machine_Tickets:61]DateEntered:5
	aPrevCC:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
End if 
rDown_Hrs:=[Job_Forms_Machine_Tickets:61]DownHrs:11  //BAK 10/17/94