app_basic_list_form_method

If ((Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>EMBOSSERS)>0) | (Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>STAMPERS)>0))
	zzDESC:=CostCtr_Description_Tweak(->[Job_Forms_Machines:43]CostCenterID:4)
Else 
	qryCostCenter([Job_Forms_Machines:43]CostCenterID:4)
	zzDESC:=[Cost_Centers:27]Description:3
End if 