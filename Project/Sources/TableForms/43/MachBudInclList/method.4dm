//(LP) [Material_Job];"MachBudInclList"
Case of 
	: (Form event code:C388=On Load:K2:1)
		[Job_Forms_Machines:43]JobForm:1:=[Job_Forms:42]JobFormID:5
		aMachDesc:=""
	: (Form event code:C388=On Display Detail:K2:22)
		gFindCC([Job_Forms_Machines:43]CostCenterID:4)
		If ((Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>EMBOSSERS)>0) | (Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>STAMPERS)>0))
			zzDESC:=CostCtr_Description_Tweak(->[Job_Forms_Machines:43]CostCenterID:4; "save")
		End if 
		aMachDesc:=zzDESC
End case 