//%attributes = {"publishedWeb":true}
//(P) gSumCY

//$k:=Month of([MachineTicket]DateEntered)-3
$k:=Month of:C24([Job_Forms_Machine_Tickets:61]DateEntered:5)
aySheets{$k}:=aySheets{$k}+[Job_Forms_Machine_Tickets:61]Good_Units:8
ayAct_MR{$k}:=ayAct_MR{$k}+[Job_Forms_Machine_Tickets:61]MR_Act:6
ayStd_MR{$k}:=ayStd_MR{$k}+[Job_Forms_Machine_Tickets:61]MR_AdjStd:14
ayAct_Run{$k}:=ayAct_Run{$k}+[Job_Forms_Machine_Tickets:61]Run_Act:7
ayStd_Run{$k}:=ayStd_Run{$k}+[Job_Forms_Machine_Tickets:61]Run_AdjStd:15
ayAct_Tot{$k}:=ayAct_Tot{$k}+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
ayStd_Tot{$k}:=ayStd_Tot{$k}+[Job_Forms_Machine_Tickets:61]MR_AdjStd:14+[Job_Forms_Machine_Tickets:61]Run_AdjStd:15
If (([Job_Forms_Machine_Tickets:61]DateEntered:5=dPrevDate) & ([Job_Forms_Machine_Tickets:61]CostCenterID:2=aPrevCC))
	//ayDown_Hrs{$k}:=ayDown_Hrs{$k}
Else 
	//gSumDownHrs  `rDownHrs
	//ayDown_Hrs{$k}:=ayDown_Hrs{$k}+rDownHrs
	dPrevDate:=[Job_Forms_Machine_Tickets:61]DateEntered:5
	aPrevCC:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
End if 
ayDown_Hrs{$k}:=ayDown_Hrs{$k}+[Job_Forms_Machine_Tickets:61]DownHrs:11