//%attributes = {"publishedWeb":true}
//(P) gSumLY

rLYSheets:=rLYSheets+[Job_Forms_Machine_Tickets:61]Good_Units:8
rLYAct_MR:=rLYAct_MR+[Job_Forms_Machine_Tickets:61]MR_Act:6
rLYStd_MR:=rLYStd_MR+[Job_Forms_Machine_Tickets:61]MR_AdjStd:14
rLYAct_Run:=rLYAct_Run+[Job_Forms_Machine_Tickets:61]Run_Act:7
rLYStd_Run:=rLYStd_Run+[Job_Forms_Machine_Tickets:61]Run_AdjStd:15
rLYAct_Tot:=rLYAct_Tot+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
rLYStd_Tot:=rLYStd_Tot+[Job_Forms_Machine_Tickets:61]MR_AdjStd:14+[Job_Forms_Machine_Tickets:61]Run_AdjStd:15
If (([Job_Forms_Machine_Tickets:61]DateEntered:5=dPrevDate) & ([Job_Forms_Machine_Tickets:61]CostCenterID:2=aPrevCC))
	//rLYDown_Hrs:=rLYDown_Hrs
Else 
	//gSumDownHrs  `rDownHrs
	//rLYDown_Hrs:=rLYDown_Hrs+rDownHrs
	dPrevDate:=[Job_Forms_Machine_Tickets:61]DateEntered:5
	aPrevCC:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
End if 
rLYDown_Hrs:=rLYDown_Hrs+[Job_Forms_Machine_Tickets:61]DownHrs:11