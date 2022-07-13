//%attributes = {"publishedWeb":true}
//PM: ams_DeleteOldProcessSpecs(cutoff) -> 
//@author mlb - 7/2/02  13:55

C_DATE:C307($cutOff; $1)

READ ONLY:C145([Finished_Goods:26])
READ WRITE:C146([Process_Specs:18])

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProcessSpec:33#"")
	util_outerJoin(->[Process_Specs:18]ID:1; ->[Finished_Goods:26]ProcessSpec:33)
	CREATE SET:C116([Process_Specs:18]; "used")
	
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]ProcessSpec:46#"")
	util_outerJoin(->[Process_Specs:18]ID:1; ->[Job_Forms:42]ProcessSpec:46)
	CREATE SET:C116([Process_Specs:18]; "usedByJob")
	UNION:C120("usedByJob"; "used"; "used")
	
	QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]ProcessSpec:23#"")
	util_outerJoin(->[Process_Specs:18]ID:1; ->[Estimates_DifferentialsForms:47]ProcessSpec:23)
	CREATE SET:C116([Process_Specs:18]; "usedByEst")
	UNION:C120("usedByEst"; "used"; "used")
	
	USE SET:C118("used")
	
	ALL RECORDS:C47([Process_Specs:18])
	CREATE SET:C116([Process_Specs:18]; "all")
	DIFFERENCE:C122("all"; "used"; "notUsed")
	USE SET:C118("notUsed")
	CLEAR SET:C117("notUsed")
	CLEAR SET:C117("used")
	CLEAR SET:C117("all")
	
	$cutOff:=$1
	$cutOff:=Add to date:C393($cutOff; 2; 0; 0)
	QUERY SELECTION:C341([Process_Specs:18]; [Process_Specs:18]LastUsed:5<$cutOff)
	
Else 
	SET QUERY DESTINATION:C396(Into set:K19:2; "used")
	QUERY BY FORMULA:C48([Process_Specs:18]; \
		(\
		([Process_Specs:18]ID:1=[Finished_Goods:26]ProcessSpec:33)\
		 & ([Finished_Goods:26]ProcessSpec:33#"")\
		)\
		 | \
		(\
		([Job_Forms:42]ProcessSpec:46=[Process_Specs:18]ID:1)\
		 & ([Job_Forms:42]ProcessSpec:46#"")\
		)\
		 | \
		(\
		([Estimates_DifferentialsForms:47]ProcessSpec:23=[Process_Specs:18]ID:1)\
		 & ([Estimates_DifferentialsForms:47]ProcessSpec:23#"")\
		)\
		)
	
	
	
	$cutOff:=$1
	$cutOff:=Add to date:C393($cutOff; 2; 0; 0)
	SET QUERY DESTINATION:C396(Into set:K19:2; "intermediateResultat")
	QUERY:C277([Process_Specs:18]; [Process_Specs:18]LastUsed:5<$cutOff)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	DIFFERENCE:C122("intermediateResultat"; "used"; "intermediateResultat")
	USE SET:C118("intermediateResultat")
	CLEAR SET:C117("used")
	CLEAR SET:C117("intermediateResultat")
	
	
End if   // END 4D Professional Services : January 2019 query selection

util_DeleteSelection(->[Process_Specs:18])
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 ams_DeleteWithoutHeaderRecord
	
	ams_DeleteWithoutHeaderRecord(->[Process_Specs_Machines:28]ProcessSpec:1; ->[Process_Specs:18]ID:1)
	
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Process_Specs:18])
		ALL RECORDS:C47([Process_Specs:18])
		READ WRITE:C146([Process_Specs_Machines:28])
		RELATE MANY SELECTION:C340([Process_Specs_Machines:28]ProcessSpec:1)
		CREATE SET:C116([Process_Specs_Machines:28]; "keepThese")
		ALL RECORDS:C47([Process_Specs_Machines:28])
		CREATE SET:C116([Process_Specs_Machines:28]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		
		
		util_DeleteSelection(->[Process_Specs_Machines:28])
		
	End if 
	
	
End if   // END 4D Professional Services : January 2019 query selection


If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 ams_DeleteWithoutHeaderRecord
	
	ams_DeleteWithoutHeaderRecord(->[Process_Specs_Materials:56]ProcessSpec:1; ->[Process_Specs:18]ID:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Process_Specs:18])
		ALL RECORDS:C47([Process_Specs:18])
		
		READ WRITE:C146([Process_Specs_Materials:56])
		RELATE MANY SELECTION:C340([Process_Specs_Materials:56]ProcessSpec:1)
		CREATE SET:C116([Process_Specs_Materials:56]; "keepThese")
		
		ALL RECORDS:C47([Process_Specs_Materials:56])
		CREATE SET:C116([Process_Specs_Materials:56]; "allRecords")
		
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		
		util_DeleteSelection(->[Process_Specs_Materials:56])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 query selection
