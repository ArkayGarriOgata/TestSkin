// _______
// Method: LockedRecords.findLocks   ( ) ->
// By: Mel Bohince @ 01/16/20, 10:23:48
// Description
// 
// ----------------------------------------------------
C_OBJECT:C1216($lockedRecordsObj; $lockInstance)
C_COLLECTION:C1488(lockedRecordCollection)

lockedRecordCollection:=New collection:C1472

$numElements:=Size of array:C274(<>axFileNums)
uThermoInit($numElements; "Looking for locked records...")
For ($table; 1; $numElements)
	
	$tablePtr:=Table:C252(<>axFileNums{$table})
	$tableName:=Table name:C256($tablePtr)
	
	$lockedRecordsObj:=util_getLockedRecords($tablePtr)  //executes on the server, returns way more detail than needed
	
	If ($lockedRecordsObj.records.length>0)  //only display table if there are locked records
		For ($record; 0; $lockedRecordsObj.records.length-1)  //for each locked record in this table
			//build an object of useful details
			$lockInstance:=New object:C1471("tableName"; $tableName; "who"; $lockedRecordsObj.records[$record].contextAttributes.user_name; "task"; $lockedRecordsObj.records[$record].contextAttributes.task_name; "machine"; $lockedRecordsObj.records[$record].contextAttributes.host_name)
			//add that object to the collection used by the listbox
			lockedRecordCollection[lockedRecordCollection.length]:=$lockInstance
		End for 
	End if 
	
	uThermoUpdate($table)
End for 
uThermoClose

