//(s)[Estimate].Input_bDelDiff

If (app_LoadIncludedSelection("init"; ->[Estimates_Differentials:38]Id:1; "DIFF")=1)
	uConfirm("Are you sure you want to delete differential "+[Estimates_Differentials:38]diffNum:3+"?"; "Delete"; "Cancel")
	If (OK=1)
		C_TEXT:C284($ID; $CaseID)
		$ID:=[Estimates_Differentials:38]estimateNum:2
		$CaseID:=[Estimates_Differentials:38]diffNum:3
		QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=$ID+$CaseID+"@")
		DELETE SELECTION:C66([Estimates_Machines:20])
		
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=$ID+$CaseID+"@")
		DELETE SELECTION:C66([Estimates_Materials:29])
		
		QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=$ID+$CaseID+"@")
		DELETE SELECTION:C66([Estimates_FormCartons:48])
		
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)
		QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=$CaseID)
		DELETE SELECTION:C66([Estimates_Carton_Specs:19])
		
		QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffId:1=$ID+$CaseID+"@")
		DELETE SELECTION:C66([Estimates_DifferentialsForms:47])
		
		DELETE RECORD:C58([Estimates_Differentials:38])
		QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1)
		ORDER BY:C49([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1; >)
		gEstimateLDWkSh("Last")
		
	Else 
		app_LoadIncludedSelection("clear"; ->[Estimates_Differentials:38]Id:1; "DIFF")
	End if 
	
Else 
	uConfirm("Select ONE differential."; "OK"; "Help")
	app_LoadIncludedSelection("clear"; ->[Estimates_Differentials:38]Id:1; "DIFF")
End if 