//%attributes = {"publishedWeb":true}
//PM: ams_DeleteWithoutEstimate() -> 
//@author mlb - 7/1/02  14:28

C_LONGINT:C283($i; $numRecs; $hit)
C_POINTER:C301($foreignKeyPtr; $1; $tablePtr)

If (<>fContinue)
	If (Count parameters:C259=1)
		$foreignKeyPtr:=$1
		$tablePtr:=Table:C252(Table:C252($foreignKeyPtr))
		
		READ WRITE:C146($tablePtr->)
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			CREATE EMPTY SET:C140($tablePtr->; "deleteThese")
			ALL RECORDS:C47($tablePtr->)
			$numRecs:=Records in selection:C76($tablePtr->)
			
			uThermoInit($numRecs; "Finding estimate orphans in "+Table name:C256($tablePtr))
			For ($i; 1; $numRecs)
				$hit:=Find in array:C230(aEstimate; Substring:C12($foreignKeyPtr->; 1; 9))
				If ($hit=-1)  //then it is an orphan
					ADD TO SET:C119($tablePtr->; "DeleteThese")
				End if 
				
				NEXT RECORD:C51($tablePtr->)
				uThermoUpdate($i)
				If (Not:C34(<>fContinue))
					$i:=$i+$numRecs
				End if 
			End for 
			uThermoClose
			
			USE SET:C118("deleteThese")
			CLEAR SET:C117("deleteThese")
			
		Else 
			ARRAY LONGINT:C221($_deleteThese; 0)
			ALL RECORDS:C47($tablePtr->)
			
			ARRAY TEXT:C222($_foreignKey; 0)
			ARRAY LONGINT:C221($_record_number; 0)
			
			SELECTION TO ARRAY:C260($foreignKeyPtr->; $_foreignKey; \
				$tablePtr->; $_record_number)
			
			$numRecs:=Records in selection:C76($tablePtr->)
			
			uThermoInit($numRecs; "Finding estimate orphans in "+Table name:C256($tablePtr))
			For ($i; 1; $numRecs)
				$hit:=Find in array:C230(aEstimate; Substring:C12($_foreignKey{$i}; 1; 9))
				If ($hit=-1)  //then it is an orphan
					APPEND TO ARRAY:C911($_deleteThese; $_record_number{$i})
					
				End if 
				
				uThermoUpdate($i)
				If (Not:C34(<>fContinue))
					$i:=$i+$numRecs
				End if 
			End for 
			uThermoClose
			CREATE SELECTION FROM ARRAY:C640($tablePtr->; $_deleteThese)
			
		End if   // END 4D Professional Services : January 2019 
		
		util_DeleteSelection($tablePtr)
		
	Else 
		ARRAY TEXT:C222(aEstimate; 0)
		READ ONLY:C145([Estimates:17])
		ALL RECORDS:C47([Estimates:17])
		SELECTION TO ARRAY:C260([Estimates:17]EstimateNo:1; aEstimate)
		REDUCE SELECTION:C351([Estimates:17]; 0)
	End if 
End if 