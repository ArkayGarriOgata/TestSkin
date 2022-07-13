//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/27/15, 15:46:00
// ----------------------------------------------------
// Method: _version20150527
// Description
// look for useless process specs
//
// ----------------------------------------------------
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	ALL RECORDS:C47([Process_Specs_Machines:28])
	DISTINCT VALUES:C339([Process_Specs_Machines:28]ProcessSpec:1; $aPSMach)
	
	QUERY WITH ARRAY:C644([Process_Specs:18]ID:1; $aPSMach)
	CREATE SET:C116([Process_Specs:18]; "hasMach")
	
	ALL RECORDS:C47([Process_Specs_Materials:56])
	DISTINCT VALUES:C339([Process_Specs_Materials:56]ProcessSpec:1; $aPSMatl)
	
	QUERY WITH ARRAY:C644([Process_Specs:18]ID:1; $aPSMatl)
	CREATE SET:C116([Process_Specs:18]; "hasMatl")
	
	UNION:C120("hasMach"; "hasMatl"; "hasBOM")
	
	ALL RECORDS:C47([Process_Specs:18])
	CREATE SET:C116([Process_Specs:18]; "allspecs")
	
	DIFFERENCE:C122("allspecs"; "hasBOM"; "noBOM")
	
	
	USE SET:C118("hasBOM")
	//USE SET("noBOM")
	
	CLEAR SET:C117("hasBOM")
	CLEAR SET:C117("hasBOM")
	CLEAR SET:C117("hasMach")
	CLEAR SET:C117("hasMatl")
	
	
Else 
	
	ALL RECORDS:C47([Process_Specs_Machines:28])
	RELATE ONE SELECTION:C349([Process_Specs_Machines:28]; [Process_Specs:18])
	CREATE SET:C116([Process_Specs:18]; "hasMach")
	ALL RECORDS:C47([Process_Specs_Materials:56])
	RELATE ONE SELECTION:C349([Process_Specs_Materials:56]; [Process_Specs:18])
	CREATE SET:C116([Process_Specs:18]; "hasMatl")
	
	UNION:C120("hasMach"; "hasMatl"; "hasBOM")
	ALL RECORDS:C47([Process_Specs:18])
	CREATE SET:C116([Process_Specs:18]; "allspecs")
	DIFFERENCE:C122("allspecs"; "hasBOM"; "noBOM")
	
	USE SET:C118("hasBOM")
	CLEAR SET:C117("hasBOM")
	CLEAR SET:C117("hasBOM")
	CLEAR SET:C117("hasMach")
	CLEAR SET:C117("hasMatl")
	
	
End if   // END 4D Professional Services : January 2019 
