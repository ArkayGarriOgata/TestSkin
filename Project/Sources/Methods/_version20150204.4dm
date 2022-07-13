//%attributes = {}

// Method: _version20150204 ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/04/15, 10:29:55
// ----------------------------------------------------
// Description
// clear out unused indexes
//
// ----------------------------------------------------
C_LONGINT:C283($table; $numTables; $field; $numFields)
C_TEXT:C284($fieldName)
C_POINTER:C301($ptrField)


//walk the structure
$numTables:=Get last table number:C254
For ($table; 1; $numTables)
	
	If (Is table number valid:C999($table))
		//get the fields
		$numFields:=Get last field number:C255($table)
		For ($field; 1; $numFields)
			If (Is field number valid:C1000($table; $field))
				$fieldName:=Field name:C257($table; $field)
				If ($fieldName="_SYNC_ID")
					$ptrField:=Field:C253($table; $field)
					DELETE INDEX:C967($ptrField)
				End if 
			End if 
		End for 
		
	End if 
	
End for 
