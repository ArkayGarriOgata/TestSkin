//%attributes = {}
// _______
// Method: util_UnloadAllTables   ( ) ->
// By: Mel Bohince @ 01/17/20, 16:16:19
// Description
// shot gun approach to cleaning up after batchrunner finishes a run
// ----------------------------------------------------
C_LONGINT:C283($table; $numOfTable)
C_POINTER:C301($tablePtr)
//test
//READ WRITE([Addresses])
//QUERY([Addresses];[Addresses]ID="00013")

$numOfTable:=Get last table number:C254

For ($table; 1; $numOfTable)  // see ams_get_tables
	
	If (Is table number valid:C999($table))
		$tablePtr:=Table:C252($table)
		UNLOAD RECORD:C212($tablePtr->)
	End if 
	
End for 
