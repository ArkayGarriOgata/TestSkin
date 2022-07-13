//(S) [MACH_BUD_JOB]CostCenter
gFindCC([Job_Forms_Machines:43]CostCenterID:4)
If (zzDESC="")
	aMachDesc:=""
	[Job_Forms_Machines:43]CostCenterID:4:=""
	ALERT:C41("Invalid Cost Center - Please try again!!!")
	REJECT:C38
Else 
	[Job_Forms_Machines:43]CostCenterID:4:=Substring:C12([Job_Forms_Machines:43]CostCenterID:4; 1; 3)
	If ((Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>EMBOSSERS)>0) | (Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>STAMPERS)>0))
		zzDESC:=CostCtr_Description_Tweak(->[Job_Forms_Machines:43]CostCenterID:4; "save")
	End if 
	aMachDesc:=zzDESC
	//[PROCESS_SPEC]Caliper:=zzGroup
End if 
//EOS