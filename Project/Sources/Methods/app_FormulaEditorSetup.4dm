//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/06/06, 11:32:04
// ----------------------------------------------------
// Method: app_FormulaEditorSetup
// Description:
// Set the allowed methods and commands for the formula editor
// for 4D2004 compliance
// ----------------------------------------------------

If (User in group:C338(Current user:C182; "RoleSuperUser"))
	ARRAY TEXT:C222($allowedMethods; 1)
	$allowedMethods{1}:="@"
	SET ALLOWED METHODS:C805($allowedMethods)
	
Else   //just some method that seem benign
	ARRAY TEXT:C222($allowedMethods; 12)
	$allowedMethods{1}:="j@"
	$allowedMethods{2}:="cust@"
	$allowedMethods{3}:="r@"
	$allowedMethods{4}:="bar@"
	$allowedMethods{5}:="fbar@"
	$allowedMethods{6}:="elc@"
	$allowedMethods{7}:="f@"
	$allowedMethods{8}:="jmi@"
	$allowedMethods{9}:="ord@"
	$allowedMethods{10}:="qry@"
	$allowedMethods{11}:="ts@"
	$allowedMethods{12}:="txt@"
End if 
SET ALLOWED METHODS:C805($allowedMethods)