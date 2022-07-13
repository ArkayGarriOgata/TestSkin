//%attributes = {"publishedWeb":true}
//PM: ams_DeleteOldEstimates() -> 
//@author mlb - 7/1/02  14:51

C_DATE:C307($estimateCutOffDate; $1; $estimateSoftCutOffDate)

$estimateCutOffDate:=$1


If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	$estimate_RecentSet:=ams_RecentEstimate($estimateCutOffDate)
	
	READ WRITE:C146([Estimates:17])
	
	ALL RECORDS:C47([Estimates:17])
	
	CREATE SET:C116([Estimates:17]; "allRecords")
	
	DIFFERENCE:C122("allRecords"; $estimate_RecentSet; "deleteThese")
	USE SET:C118("deleteThese")
	
	$estimate_RecentSet:=ams_RecentEstimate
	CLEAR SET:C117("deleteThese")
	CLEAR SET:C117("allRecords")
	
Else 
	//see line 10
	
	READ WRITE:C146([Estimates:17])
	QUERY:C277([Estimates:17]; [Estimates:17]DateOriginated:19<$estimateCutOffDate)
	
End if   // END 4D Professional Services : January 2019 

util_DeleteSelection(->[Estimates:17])

$estimateSoftCutOffDate:=Add to date:C393($estimateCutOffDate; 1; 0; 0)
QUERY:C277([Estimates:17]; [Estimates:17]Status:30="New"; *)
QUERY:C277([Estimates:17];  | ; [Estimates:17]Status:30="Hold"; *)
QUERY:C277([Estimates:17];  | ; [Estimates:17]Status:30="Quoted"; *)
QUERY:C277([Estimates:17];  & ; [Estimates:17]DateOriginated:19<$estimateSoftCutOffDate)
util_DeleteSelection(->[Estimates:17])

QUERY:C277([Estimates:17]; [Estimates:17]Status:30="Kill"; *)
QUERY:C277([Estimates:17];  | ; [Estimates:17]Status:30="Superceded")
util_DeleteSelection(->[Estimates:17])

//go after all tables that reference the Estimate Number
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Estimates_Carton_Specs:19]Estimate_No:2; ->[Estimates:17]EstimateNo:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Estimates:17])
		ALL RECORDS:C47([Estimates:17])
		READ WRITE:C146([Estimates_Carton_Specs:19])
		RELATE MANY SELECTION:C340([Estimates_Carton_Specs:19]Estimate_No:2)
		CREATE SET:C116([Estimates_Carton_Specs:19]; "keepThese")
		ALL RECORDS:C47([Estimates_Carton_Specs:19])
		CREATE SET:C116([Estimates_Carton_Specs:19]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Estimates_Carton_Specs:19])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Estimates_Differentials:38]estimateNum:2; ->[Estimates:17]EstimateNo:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Estimates:17])
		ALL RECORDS:C47([Estimates:17])
		READ WRITE:C146([Estimates_Differentials:38])
		If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
			
			ARRAY TEXT:C222($_Jobit; 0)
			DISTINCT VALUES:C339([Estimates:17]EstimateNo:1; $_EstimateNo)
			SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
			QUERY WITH ARRAY:C644([Estimates_Differentials:38]estimateNum:2; $_EstimateNo)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
		Else 
			
			RELATE MANY SELECTION:C340([Estimates_Differentials:38]estimateNum:2)
			CREATE SET:C116([Estimates_Differentials:38]; "keepThese")
			
			
		End if   // END 4D Professional Services : January 2019 
		ALL RECORDS:C47([Estimates_Differentials:38])
		CREATE SET:C116([Estimates_Differentials:38]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Estimates_Differentials:38])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Estimates_PSpecs:57]EstimateNo:1; ->[Estimates:17]EstimateNo:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Estimates:17])
		ALL RECORDS:C47([Estimates:17])
		READ WRITE:C146([Estimates_PSpecs:57])
		RELATE MANY SELECTION:C340([Estimates_PSpecs:57]EstimateNo:1)
		CREATE SET:C116([Estimates_PSpecs:57]; "keepThese")
		ALL RECORDS:C47([Estimates_PSpecs:57])
		CREATE SET:C116([Estimates_PSpecs:57]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Estimates_PSpecs:57])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

//ams_DeleteWithoutHeaderRecord (->[Est_Ship_tos]EstimateNum;->[ESTIMATE]EstimateN
//ams_DeleteWithoutHeaderRecord (->[_obsolete_Prep_Specs]EstimateNo;->[Estimates]EstimateNo)
//ams_DeleteWithoutHeaderRecord (->[ReproKits]EstimateNo;->[ESTIMATE]EstimateNo)

ams_DeleteWithoutEstimate
ams_DeleteWithoutEstimate(->[Estimates_DifferentialsForms:47]DiffFormId:3)
ams_DeleteWithoutEstimate(->[Estimates_Materials:29]DiffFormID:1)
ams_DeleteWithoutEstimate(->[Estimates_Machines:20]DiffFormID:1)
ams_DeleteWithoutEstimate(->[Estimates_FormCartons:48]DiffFormID:2)
//ams_DeleteWithoutEstimate (->[_obsolete_Estimates_SubForms]DiffFormId)
ARRAY TEXT:C222(aEstimate; 0)