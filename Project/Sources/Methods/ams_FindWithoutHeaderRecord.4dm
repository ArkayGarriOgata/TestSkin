//%attributes = {}

// Method: ams_FindWithoutHeaderRecord (->foreignKey;->primaryKey{;keepSetName}) ->  
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/05/15, 08:56:17
// ----------------------------------------------------
// Description
// based on ams_DeleteWithoutHeaderRecord
//
// ----------------------------------------------------

C_POINTER:C301($1; $2; $foreignKeyPtr; $tablePtr; $primaryKeyPtr; $headerTablePtr)
C_TEXT:C284($keepSet; $3)  //keep set created before call to reserve any special records

If (<>fContinue)
	$foreignKeyPtr:=$1
	$tablePtr:=Table:C252(Table:C252($foreignKeyPtr))
	$primaryKeyPtr:=$2
	$headerTablePtr:=Table:C252(Table:C252($primaryKeyPtr))
	
	READ ONLY:C145($headerTablePtr->)
	ALL RECORDS:C47($headerTablePtr->)
	
	READ WRITE:C146($tablePtr->)
	util_outerJoin($foreignKeyPtr; $primaryKeyPtr)  // these have a header record
	CREATE SET:C116($tablePtr->; "keepThese")
	
	ALL RECORDS:C47($tablePtr->)
	CREATE SET:C116($tablePtr->; "allRecords")
	
	DIFFERENCE:C122("allRecords"; "keepThese"; "deleteThese")
	
	If (Count parameters:C259=3)
		$keepSet:=$3
		DIFFERENCE:C122("deleteThese"; $keepSet; "deleteThese")
	End if 
	
	USE SET:C118("deleteThese")
	CLEAR SET:C117("allRecords")
	CLEAR SET:C117("keepThese")
	CLEAR SET:C117("deleteThese")
	//
	//util_DeleteSelection ($tablePtr)
	//
End if 