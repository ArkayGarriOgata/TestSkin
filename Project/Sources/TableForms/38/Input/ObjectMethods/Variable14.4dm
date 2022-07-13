//upr 165 1/4/94
//1/5/94 delete related carton specs

If (app_LoadIncludedSelection("init"; ->[Estimates_DifferentialsForms:47]FormNumber:2; "FORM")=1)
	uConfirm("Are you sure you want to delete form "+String:C10([Estimates_DifferentialsForms:47]FormNumber:2)+"?"; "Delete"; "Cancel")
	If (OK=1)
		C_TEXT:C284($ID)
		$ID:=[Estimates_DifferentialsForms:47]DiffFormId:3
		QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=$ID)
		util_DeleteSelection(->[Estimates_Machines:20])
		
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=$ID)
		util_DeleteSelection(->[Estimates_Materials:29])
		
		QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=$ID)
		RELATE ONE SELECTION:C349([Estimates_FormCartons:48]; [Estimates_Carton_Specs:19])  //1/5/94
		util_DeleteSelection(->[Estimates_Carton_Specs:19])  //1/5/94
		util_DeleteSelection(->[Estimates_FormCartons:48])
		
		util_DeleteSelection(->[Estimates_DifferentialsForms:47])
		
		QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffId:1=[Estimates_Differentials:38]Id:1)
		[Estimates_Differentials:38]NumForms:4:=Records in selection:C76([Estimates_DifferentialsForms:47])+1  //already set to 1 above
		
		SAVE RECORD:C53([Estimates_Differentials:38])
		ORDER BY:C49([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffFormId:3; >)
		REDRAW:C174([Estimates_DifferentialsForms:47])
		Estimate_ReCalcNeeded
		gEstimateLDWkSh("Diff")
		
	Else 
		app_LoadIncludedSelection("clear"; ->[Estimates_DifferentialsForms:47]FormNumber:2; "FORM")
	End if 
	
Else 
	uConfirm("Select ONE form."; "OK"; "Help")
	app_LoadIncludedSelection("clear"; ->[Estimates_DifferentialsForms:47]FormNumber:2; "FORM")
End if 