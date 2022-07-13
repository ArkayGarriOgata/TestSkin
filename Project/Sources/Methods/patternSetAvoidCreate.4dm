//%attributes = {}
// -------
// Method: patternAvoidCreateSet   ( ) ->
// By: Mel Bohince @ 03/27/19, 09:18:20
// Description
// use a record number array instead of a set
// ----------------------------------------------------

$betterWay:=False:C215

If (Not:C34($betterWay))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	CREATE SET:C116([Estimates_Machines:20]; "machines")
	
Else   //get an array instead
	ARRAY LONGINT:C221($_record_machines; 0)
	LONGINT ARRAY FROM SELECTION:C647([Estimates_Machines:20]; $_record_machines)
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34($betterWay))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	USE SET:C118("machines")
	CLEAR SET:C117("machines")
	
Else 
	
	CREATE SELECTION FROM ARRAY:C640([Estimates_Machines:20]; $_record_machines)
	
End if   // END 4D Professional Services : January 2019 
