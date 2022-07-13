
If (<>pid_Workorder=0)
	WO_WorkOrder
Else 
	SHOW PROCESS:C325(<>pid_Workorder)
	BRING TO FRONT:C326(<>pid_Workorder)
End if 
