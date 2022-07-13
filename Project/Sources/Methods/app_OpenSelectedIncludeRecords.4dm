//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 06/13/06, 16:09:11
// ----------------------------------------------------
// Method: app_OpenSelectedIncludeRecords(->primaryKey)
// Description
// See also app_SelectIncludedRecords
// ----------------------------------------------------

C_POINTER:C301($primaryKeyPt; $1; $tablePtr; $searchArrayPtr)
C_TEXT:C284($tableName)
C_LONGINT:C283($2; $mode; $type)
ARRAY TEXT:C222($alphaKey; 0)
ARRAY LONGINT:C221($numericKey; 0)

$primaryKeyPtr:=$1
$tablePtr:=Table:C252(Table:C252($primaryKeyPtr))
$tableName:=Table name:C256($tablePtr)
GET FIELD PROPERTIES:C258($primaryKeyPtr; $type)
If (($type=0) | ($type=2) | ($type=24))  //string, text or string)
	$searchArrayPtr:=->$alphaKey
Else 
	$searchArrayPtr:=->$numericKey
End if 

C_TEXT:C284($selectionSetName)
C_TEXT:C284($3)
If (Count parameters:C259>=3)
	$selectionSetName:="clickedIncludeRecord"+$3
Else 
	$selectionSetName:="clickedIncludeRecord"
End if 

If (Records in set:C195($selectionSetName)>0)
	UNLOAD RECORD:C212($tablePtr->)
	CUT NAMED SELECTION:C334($tablePtr->; "holdNamedSelectionBefore")
	
	USE SET:C118($selectionSetName)
	//CLEAR SET("clickedIncludeRecord")
	SELECTION TO ARRAY:C260($primaryKeyPtr->; $searchArrayPtr->)
	
	If (Not:C34(Read only state:C362($tablePtr->)))
		READ ONLY:C145($tablePtr->)
		makeReadWrite:=True:C214
	Else 
		makeReadWrite:=False:C215
	End if 
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY WITH ARRAY:C644($primaryKeyPtr->; $searchArrayPtr->)
		
		CREATE SET:C116($tablePtr->; "◊PassThroughSet")
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
		QUERY WITH ARRAY:C644($primaryKeyPtr->; $searchArrayPtr->)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
	End if   // END 4D Professional Services : January 2019 
	
	<>PassThrough:=True:C214
	If (Count parameters:C259>=2)
		$mode:=$2
		If ($mode=0)
			If (iMode=1)
				$mode:=2
			Else 
				$mode:=iMode
			End if 
		End if 
	Else 
		If (iMode=1)
			$mode:=2
		Else 
			$mode:=iMode
		End if 
	End if 
	ViewSetter($mode; $tablePtr)
	
	If (makeReadWrite)
		READ WRITE:C146($tablePtr->)
	End if 
	USE NAMED SELECTION:C332("holdNamedSelectionBefore")
	
Else 
	uConfirm("Please select a "+$tableName+" record(s) to open."; "OK"; "Help")
End if 