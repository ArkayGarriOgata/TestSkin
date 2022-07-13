//%attributes = {"publishedWeb":true}
//PM: ams_DeleteOldRMgroups() -> 
//@author mlb - 7/3/02  14:59
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]UseForEst:12=True:C214)
	CREATE SET:C116([Raw_Materials_Groups:22]; "Keepers")
	ams_DeleteWithoutHeaderRecord(->[Raw_Materials_Groups:22]Commodity_Key:3; ->[Raw_Materials:21]Commodity_Key:2; "Keepers")
	CLEAR SET:C117("Keepers")
	
Else 
	
	SET QUERY DESTINATION:C396(Into set:K19:2; "Keepers")
	QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]UseForEst:12=True:C214)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	If (<>fContinue)
		
		READ ONLY:C145([Raw_Materials:21])
		ALL RECORDS:C47([Raw_Materials:21])
		
		READ WRITE:C146([Raw_Materials_Groups:22])
		RELATE ONE SELECTION:C349([Raw_Materials:21]; [Raw_Materials_Groups:22])
		CREATE SET:C116([Raw_Materials_Groups:22]; "keepThese")
		
		ALL RECORDS:C47([Raw_Materials_Groups:22])
		CREATE SET:C116([Raw_Materials_Groups:22]; "allRecords")
		
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		DIFFERENCE:C122("keepThese"; "Keepers"; "keepThese")
		
		
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		
		util_DeleteSelection(->[Raw_Materials_Groups:22])
		
	End if 
	
	CLEAR SET:C117("Keepers")
	
	
End if   // END 4D Professional Services : January 2019 
