
If (<>pid_WIPmgmt=0)
	WIP_ManageShipments
Else 
	SHOW PROCESS:C325(<>pid_WIPmgmt)
	BRING TO FRONT:C326(<>pid_WIPmgmt)
End if 
