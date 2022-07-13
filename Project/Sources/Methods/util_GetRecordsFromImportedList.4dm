//%attributes = {}
// -------
// Method: util_GetRecordsFromImportedList   ( ) ->
// By: Mel Bohince @ 01/31/19, 14:29:02
// Description
// given a textfile of primary keys, select matching records, run in admin process
// use to find items to restore from a purged set
// see also util_GetRecordDuplicates
// ----------------------------------------------------



//open and read file into array
C_LONGINT:C283($position; $length; $imports; $winRef)
C_POINTER:C301($targetField)
C_BLOB:C604($theBlob)
SET BLOB SIZE:C606($theBlob; 0)
$docRef:=Open document:C264("")
CLOSE DOCUMENT:C267($docRef)
DOCUMENT TO BLOB:C525(Document; $theBlob)

$length:=BLOB size:C605($theBlob)-1
If ($length>2)  //arbitrarily small, but not empty
	
	ARRAY TEXT:C222($aImportedKeys; 0)
	$element:=""
	For ($position; 0; $length)
		$charNumber:=$theBlob{$position}
		If ($charNumber=13) | ($charNumber=10)
			If (Length:C16($element)>0)
				APPEND TO ARRAY:C911($aImportedKeys; $element)
			End if 
			$element:=""
		Else 
			$element:=$element+Char:C90($charNumber)
		End if 
	End for 
	
	If (Length:C16($element)>0)
		APPEND TO ARRAY:C911($aImportedKeys; $element)
	End if 
	
	$imports:=Size of array:C274($aImportedKeys)
	//make selection
	fieldPtr:=Field:C253(1; 1)  //set in dialog
	$winRef:=Open form window:C675("Table_Field_Picker")
	DIALOG:C40("Table_Field_Picker")
	CLOSE WINDOW:C154($winRef)
	//ams_get_tables //<>axFiles and <>axFileNums
	//then when picked
	//ams_get_fields (<>axFileNums{Box4})
	//aFieldNames;aFieldNums
	If (ok=1)
		$targetField:=fieldPtr  //->[Finished_Goods_SizeAndStyles]FileOutlineNum  //for future development
		$table:=Table:C252(Table:C252($targetField))
		
		QUERY WITH ARRAY:C644($targetField->; $aImportedKeys)
		
		$selection:=Records in selection:C76($table->)
		
		If ($imports#$selection)
			
			ALERT:C41(String:C10($imports)+" in the import "+String:C10($selection)+" selected.")
			
		End if 
		
	End if   //field picked
End if   //not empty blob

SET BLOB SIZE:C606($theBlob; 0)
BEEP:C151

