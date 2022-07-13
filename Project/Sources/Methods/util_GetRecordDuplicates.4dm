//%attributes = {}
// _______
// Method: util_GetRecordDuplicates   ( ) ->
// By: Mel Bohince @ 04/04/19, 14:05:55
// Description
// find records that duplicate a field that should be unique, prolly due to an import
// see also util_GetRecordsFromImportedList
// ----------------------------------------------------
C_POINTER:C301($ptrField; $ptrTable)
fieldPtr:=Field:C253(1; 1)  //set in dialog
$winRef:=Open form window:C675("Table_Field_Picker")
DIALOG:C40("Table_Field_Picker")
CLOSE WINDOW:C154($winRef)

$ptrField:=fieldPtr  //->[Finished_Goods_SizeAndStyles]FileOutlineNum
$ptrTable:=Table:C252(Table:C252($ptrField))

ALL RECORDS:C47($ptrTable->)

ARRAY LONGINT:C221($_recordNumbers; 0)
ARRAY TEXT:C222($_uniqueKey; 0)
SELECTION TO ARRAY:C260($ptrTable->; $_recordNumbers; $ptrField->; $_uniqueKey)  //load the record numbers and the *unique* values

REDUCE SELECTION:C351($ptrTable->; 0)

ARRAY LONGINT:C221($_recordNumbersOfDuplicates; 0)  // will put duplicate records here

SORT ARRAY:C229($_uniqueKey; $_recordNumbers; >)  //order by the unique so we can compare in brute force

C_LONGINT:C283($i; $numElements)
$numElements:=Size of array:C274($_uniqueKey)
uThermoInit($numElements; "Looking for duplicates of "+Field name:C257($ptrField))
$lastUniqueKey:=""

For ($i; 1; $numElements)
	If ($_uniqueKey{$i}=$lastUniqueKey)  //current is same as last, so grab it's record number
		APPEND TO ARRAY:C911($_recordNumbersOfDuplicates; $_recordNumbers{$i})
	End if 
	$lastUniqueKey:=$_uniqueKey{$i}
	
	uThermoUpdate($i)
End for 
uThermoClose

CREATE SELECTION FROM ARRAY:C640($ptrTable->; $_recordNumbersOfDuplicates)  //these were found to contain duplicates

//now find the matching records so both can be displayed
ARRAY TEXT:C222($_uniqueKey; 0)
SELECTION TO ARRAY:C260($ptrField->; $_uniqueKey)  //

QUERY WITH ARRAY:C644($ptrField->; $_uniqueKey)
ORDER BY:C49($ptrTable->; $ptrField->; >)

BEEP:C151


