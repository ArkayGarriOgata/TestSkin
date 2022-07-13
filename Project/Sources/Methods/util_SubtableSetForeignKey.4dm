//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 11/04/10, 10:34:12
// ----------------------------------------------------
// Method: util_SubtableSetForeignKey($ptrPrimaryKey_ParentTable;$ptrForeignKey_SubTable;$ptrParentSubTableField;$ptrSubTableField_AddedByConverter)
// Description
// Set a foreignKey in a subtable so that it may handled as a normal table
//****Before Running: remove special relation link and make sure there is foreignkey field available
// Parameters
// ----------------------------------------------------
C_POINTER:C301($ptrPrimaryKey_ParentTable; $1; $ptrForeignKey_SubTable; $2; $ptrParentSubTableField; $3; $ptrSubTableField_AddedByConvert; $4)

If (Count parameters:C259=2)
	$ptrPrimaryKey_ParentTable:=$1
	$ptrForeignKey_SubTable:=$2
	$ptrParentSubTableField:=$3
	$ptrSubTableField_AddedByConvert:=$4
Else 
	$ptrPrimaryKey_ParentTable:=->[y_batches:10]BatchName:1
	$ptrForeignKey_SubTable:=->[y_batch_distributions:164]future:6
	$ptrParentSubTableField:=->[y_batches:10]_future2:8
	$ptrSubTableField_AddedByConvert:=->[y_batch_distributions:164]future:6
End if 

$ptrParentTable:=Table:C252(Table:C252($ptrPrimaryKey_ParentTable))
$ptrSubTable:=Table:C252(Table:C252($ptrForeignKey_SubTable))

ALL RECORDS:C47($ptrParentTable->)
READ WRITE:C146($ptrSubTable->)

C_LONGINT:C283($i; $numRecs; $splField)
$numRecs:=Records in selection:C76($ptrParentTable->)
$i:=0
uThermoInit($numRecs; "Updating "+Table name:C256($ptrSubTable)+"Records")
While (Not:C34(End selection:C36($ptrParentTable->)))
	$splField:=$ptrParentSubTableField->
	
	QUERY:C277($ptrSubTable->; $ptrSubTableField_AddedByConvert->=$splField)
	While (Not:C34(End selection:C36($ptrSubTable->)))
		$ptrForeignKey_SubTable->:=$ptrPrimaryKey_ParentTable->
		SAVE RECORD:C53($ptrSubTable->)
		NEXT RECORD:C51($ptrSubTable->)
	End while 
	
	NEXT RECORD:C51($ptrParentTable->)
	uThermoUpdate($i)
	$i:=$i+1
End while 
uThermoClose