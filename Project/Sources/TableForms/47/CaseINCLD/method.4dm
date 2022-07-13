Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		util_alternateBackground
		
End case 
app_SelectIncludedRecords(->[Estimates_DifferentialsForms:47]DiffFormId:3; 0; "FORM")
Case of 
	: (Form event code:C388=On Double Clicked:K2:5)  //reestablish selection
		USE NAMED SELECTION:C332("cartonsInDifferential")
		
	: (Form event code:C388=On Clicked:K2:4)  //highlite cartons on this form
		CUT NAMED SELECTION:C334([Estimates_DifferentialsForms:47]; "beforeHilite")
		USE SET:C118("clickedIncludeRecordFORM")
		$formId:=[Estimates_DifferentialsForms:47]DiffFormId:3
		USE NAMED SELECTION:C332("beforeHilite")
		HIGHLIGHT RECORDS:C656("clickedIncludeRecordFORM")
		
		CUT NAMED SELECTION:C334([Estimates_Carton_Specs:19]; "diffCartons")
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=$formId)
			SELECTION TO ARRAY:C260([Estimates_FormCartons:48]Carton:1; $cartonSpecKey)
			
			QUERY WITH ARRAY:C644([Estimates_Carton_Specs:19]CartonSpecKey:7; $cartonSpecKey)
			CREATE SET:C116([Estimates_Carton_Specs:19]; "clickedIncludeRecordCSPEC")
			
		Else 
			
			SET QUERY DESTINATION:C396(Into set:K19:2; "clickedIncludeRecordCSPEC")
			QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_FormCartons:48]DiffFormID:2=$formId)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
		End if   // END 4D Professional Services : January 2019 
		
		USE NAMED SELECTION:C332("diffCartons")
		HIGHLIGHT RECORDS:C656("clickedIncludeRecordCSPEC")
End case 