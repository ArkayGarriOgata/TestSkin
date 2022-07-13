//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 04/28/06, 14:42:46
// ----------------------------------------------------
// Method: util_openTheSelectRecordInList
// ----------------------------------------------------

C_POINTER:C301($1; $ptrForeignKey; $2; $ptrPrimaryKey; $ptrRelationTable; $ptrTargetTable)
C_LONGINT:C283($0; $n; $3)  //optional mode

$ptrForeignKey:=$1
$ptrRelationTable:=Table:C252(Table:C252($ptrForeignKey))
$ptrPrimaryKey:=$2
$ptrTargetTable:=Table:C252(Table:C252($ptrPrimaryKey))

GET HIGHLIGHTED RECORDS:C902($ptrRelationTable->; "SelectedSubRecords")
$n:=Records in set:C195("SelectedSubRecords")
If ($n#0)
	CUT NAMED SELECTION:C334($ptrRelationTable->; "CurrentSelectionOfSubRecords")
	USE SET:C118("SelectedSubRecords")
	ARRAY TEXT:C222($aContactIDs; 0)
	SELECTION TO ARRAY:C260($ptrForeignKey->; $aContactIDs)
	
	READ ONLY:C145($ptrTargetTable->)
	QUERY WITH ARRAY:C644($ptrPrimaryKey->; $aContactIDs)
	CREATE SET:C116($ptrTargetTable->; "◊PassThroughSet")
	<>PassThrough:=True:C214
	If (Count parameters:C259>=3)
		$iMode:=$3
	Else 
		$iMode:=iMode
	End if 
	ViewSetter($iMode; $ptrTargetTable)
	
	If ($ptrForeignKey#$ptrPrimaryKey)
		REDUCE SELECTION:C351($ptrTargetTable->; 0)
	End if 
	ARRAY TEXT:C222($aContactIDs; 0)
	
	USE NAMED SELECTION:C332("CurrentSelectionOfSubRecords")
	HIGHLIGHT RECORDS:C656("SelectedSubRecords")
	
Else 
	uConfirm("Select a linked record to open."; "OK"; "Help")
End if 
CLEAR SET:C117("SelectedSubRecords")
$0:=$n