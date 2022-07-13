app_basic_list_form_method

If ((Position:C15([Estimates_Machines:20]CostCtrID:4; <>EMBOSSERS)>0) | (Position:C15([Estimates_Machines:20]CostCtrID:4; <>STAMPERS)>0))
	$shouldUse:=CostCtr_Description_Tweak(->[Estimates_Machines:20]CostCtrName:2; "save")
End if 
// ----------------------------------------------------
// Method: [Estimates_Machines].List   ( ) ->
