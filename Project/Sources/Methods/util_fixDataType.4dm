//%attributes = {}
// Method: util_fixDataType () -> 
// ----------------------------------------------------
// by: From the Committed Software web site. 
// ----------------------------------------------------
// Description:

//datacheck_touchall 
//there is no copyright on this code -- use it as you wish. 
//however, if it breaks something, that's your problem. 
//doing ANYTHING to a suspect data file can cause further damage 
//MAKE BACKUPS before using any tool or running any method on suspect data files. 
C_LONGINT:C283($table; $field; $rec)
C_POINTER:C301($pFile; $pField)
For ($table; 1; Get last table number:C254)
	If (Is table number valid:C999($table))
		$pFile:=Table:C252($table)
		$aName:="["+Table name:C256($pFile)+"]"
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			ALL RECORDS:C47($pFile->)
			FIRST RECORD:C50($pFile->)
			
			
		Else 
			
			ALL RECORDS:C47($pFile->)
			
		End if   // END 4D Professional Services : January 2019 First record
		
		$nRecs:=Records in selection:C76($pFile->)
		For ($rec; 1; $nRecs)
			If ($rec%1000=0)
				MESSAGE:C88("Touching "+$aName+" "+String:C10($nRecs-$rec))
			End if 
			For ($field; 1; Get last field number:C255($pFile))
				$pField:=Field:C253($table; $field)
				$pField->:=$pField->
			End for 
			SAVE RECORD:C53($pFile->)
			NEXT RECORD:C51($pFile->)
		End for 
		FLUSH CACHE:C297
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			
			UNLOAD RECORD:C212($pFile->)
			
		Else 
			
			// you have next record 40
			
		End if   // END 4D Professional Services : January 2019 
		
	End if 
End for 
FLUSH CACHE:C297
