//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/26/06, 10:48:54
// ----------------------------------------------------
// Method: Estimate_DupSimple(->ptrKeyField;olddiff;newdiff)
// ----------------------------------------------------

C_POINTER:C301($ptrField; $1; $ptrTable; $sync_id; $sync_data; $pkid)
C_TEXT:C284($oldDiffID; $2; $newDiffID; $3; $tableName)
C_LONGINT:C283($item; $collectionSize)

$ptrField:=$1
$oldDiffID:=$2
$newDiffID:=$3
$ptrTable:=Table:C252(Table:C252($ptrField))
$tableName:=Table name:C256($ptrTable)

Case of 
	: ($tableName="Estimates_Machines")
		$sync_id:=->[Estimates_Machines:20]_SYNC_ID:46
		$sync_data:=->[Estimates_Machines:20]_SYNC_DATA:47
		$pkid:=->[Estimates_Machines:20]pk_id:48
	: ($tableName="Estimates_Materials")
		$sync_id:=->[Estimates_Materials:29]z_SYNC_ID:31
		$sync_data:=->[Estimates_Materials:29]z_SYNC_DATA:32
		$pkid:=->[Estimates_Materials:29]pk_id:33
	Else 
		$tableName:=""
		ALERT:C41("'"+$tableName+"' was not expected by Estimate_DupSimple, Dup record will not Sync properly")
End case 

QUERY:C277($ptrTable->; $ptrField->=$oldDiffID+"@")
$collectionSize:=Records in selection:C76($ptrTable->)
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 GOTO SELECTED RECORD
	
	CREATE SET:C116($ptrTable->; "dupingSet")
	For ($item; 1; $collectionSize)
		USE SET:C118("dupingSet")
		GOTO SELECTED RECORD:C245($ptrTable->; $item)
		
		DUPLICATE RECORD:C225($ptrTable->)
		$ptrField->:=$newDiffID+Substring:C12($ptrField->; 12)
		If (Length:C16($tableName)>0)
			// deleted 5/15/20: gns_ams_clear_sync_fields($sync_id;$sync_data)
			$pkid->:=Generate UUID:C1066
		End if 
		SAVE RECORD:C53($ptrTable->)
	End for 
	
	CLEAR SET:C117("dupingSet")
	
Else 
	
	ARRAY LONGINT:C221($_dupingSet; 0)
	LONGINT ARRAY FROM SELECTION:C647($ptrTable->; $_dupingSet)
	For ($item; 1; $collectionSize)
		GOTO RECORD:C242($ptrTable->; $_dupingSet{$item})
		DUPLICATE RECORD:C225($ptrTable->)
		$ptrField->:=$newDiffID+Substring:C12($ptrField->; 12)
		If (Length:C16($tableName)>0)
			// deleted 5/15/20: gns_ams_clear_sync_fields($sync_id;$sync_data)
			$pkid->:=Generate UUID:C1066
		End if 
		SAVE RECORD:C53($ptrTable->)
	End for 
	
End if   // END 4D Professional Services : January 2019 

