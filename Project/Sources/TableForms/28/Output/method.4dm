If ((Position:C15([Process_Specs_Machines:28]CostCenterID:4; <>EMBOSSERS)>0) | (Position:C15([Process_Specs_Machines:28]CostCenterID:4; <>STAMPERS)>0))
	$shouldUse:=CostCtr_Description_Tweak(->[Process_Specs_Machines:28]CostCtrName:5; "save")
End if 