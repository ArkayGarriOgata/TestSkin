//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 06/13/06, 16:15:14
// ----------------------------------------------------
// Method: app_SelectIncludedRecords
// Description
// see also app_OpenSelectedIncludeRecords
// ----------------------------------------------------

C_LONGINT:C283($2; $mode; $e)
C_TEXT:C284($selectionSetName)
C_TEXT:C284($3)

$primaryKeyPtr:=$1
$tablePtr:=Table:C252(Table:C252($primaryKeyPtr))
If (Count parameters:C259>=3)
	$selectionSetName:="clickedIncludeRecord"+$3
Else 
	$selectionSetName:="clickedIncludeRecord"
End if 

$e:=Form event code:C388
Case of 
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902($tablePtr->; $selectionSetName)
		
	: ($e=On Double Clicked:K2:5)
		app_OpenDoubleClickedRecord($tablePtr; iMode)
		
End case 