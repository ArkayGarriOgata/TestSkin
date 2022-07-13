//%attributes = {}
//Method:  Core_Field_DocumentAscii(pField)
//Description:  This method will 

If (True:C214)  //Initialize 
	
	C_POINTER:C301($1; $pField)
	
	C_LONGINT:C283($nRecord; $nNumberOfRecords)
	C_LONGINT:C283($nCharacter; $nNumberOfCharacters)
	C_LONGINT:C283($nAscii; $nNumberOfAsciis)
	
	C_TEXT:C284($tCharacter; $tDocumentName; $tFieldName; $tTableName)
	
	C_OBJECT:C1216($oProgress)
	
	ARRAY TEXT:C222($atAscii; 0)
	ARRAY LONGINT:C221($anAscii; 0)
	
	ARRAY POINTER:C280($apColumn; 0)
	
	$pField:=$1
	
	APPEND TO ARRAY:C911($apColumn; ->$atAscii)
	
	$pTable:=Table:C252(Table:C252($pField))
	
	$tTableName:=Table name:C256($pTable)
	$tFieldName:=Field name:C257($pField)
	
	$tDocumentName:=CorektLeftBracket+$tTableName+CorektRightBracket+$tFieldName
	
	ALL RECORDS:C47($pTable->)
	
	$nNumberOfRecords:=Records in selection:C76($pTable->)
	
	$oProgress:=New object:C1471()
	
	$oProgress.nProgressID:=Prgr_NewN
	$oProgress.nNumberOfLoops:=$nNumberOfRecords
	$oProgress.tTitle:="Looping thru ProductCode fields"
	
End if   //Done Initialize

For ($nRecord; 1; $nNumberOfRecords)  //[Finished_Goods]
	
	$oProgress.nLoop:=$nRecord
	$oProgress.tMessage:=String:C10($nRecord)+" of "+String:C10($nNumberOfRecords)
	Prgr_Message($oProgress)
	
	GOTO SELECTED RECORD:C245($pTable->; $nRecord)
	
	$nNumberOfCharacters:=Length:C16($pField->)
	
	For ($nCharacter; 1; $nNumberOfCharacters)  //Characters
		
		$tCharacter:=$pField->[[$nCharacter]]
		
		$nAscii:=Character code:C91($tCharacter)
		
		If (Find in array:C230($anAscii; $nAscii)=CoreknNoMatchFound)
			
			APPEND TO ARRAY:C911($anAscii; $nAscii)
			
		End if 
		
	End for   //Done characters
	
End for   //Done[Finished_Goods]

Prgr_Quit($oProgress)

SORT ARRAY:C229($anAscii; >)

$nNumberOfAsciis:=Size of array:C274($anAscii)

For ($nAscii; 1; $nNumberOfAsciis)  //Loop through Ascii
	
	APPEND TO ARRAY:C911($atAscii; String:C10($anAscii{$nAscii}))
	
End for   //Done looping through Ascii

Core_Array_ToDocument(->$apColumn; $tDocumentName)
