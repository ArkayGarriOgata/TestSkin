//%attributes = {}
// -------
// Method: util_SumSelectedRecords   ( ->numeric_field) -> sumation of that field
// By: Mel Bohince @ 08/26/16, 14:47:40
// Description
// 
// ----------------------------------------------------

C_POINTER:C301($1; $fieldPtr; $tablePtr)
C_LONGINT:C283($rec; $numSelected)
C_REAL:C285($0; $total)

$fieldPtr:=$1
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	$total:=0
	$numSelected:=Records in selection:C76($tablePtr->)
	$tablePtr:=Table:C252(Table:C252($fieldPtr))
	
	For ($rec; 1; $numSelected)
		$total:=$total+$fieldPtr->
		NEXT RECORD:C51($tablePtr->)
	End for 
	
Else 
	
	$total:=Sum:C1($fieldPtr->)
	
End if   // END 4D Professional Services : January 2019 

$0:=$total
