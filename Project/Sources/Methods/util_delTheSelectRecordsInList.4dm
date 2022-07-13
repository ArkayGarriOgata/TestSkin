//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 04/28/06, 15:55:07
// ----------------------------------------------------
// Method: util_delTheSelectRecordsInList
// ----------------------------------------------------

C_POINTER:C301($1; $ptrTargetTable)
C_LONGINT:C283($0; $n)

$ptrTargetTable:=$1

GET HIGHLIGHTED RECORDS:C902($ptrTargetTable->; "SelectedSubRecords")
$n:=Records in set:C195("SelectedSubRecords")
If ($n#0)
	CUT NAMED SELECTION:C334($ptrTargetTable->; "CurrentSelectionOfSubRecords")
	USE SET:C118("SelectedSubRecords")
	CONFIRM:C162("Remove the "+String:C10($n)+" selected linked records?"; "Remove Link"; "Cancel")
	If (ok=1)
		util_DeleteSelection($ptrTargetTable)
	End if 
	USE NAMED SELECTION:C332("CurrentSelectionOfSubRecords")
	
Else 
	uConfirm("Select linked record(s) to unlink."; "OK"; "Help")
End if 
CLEAR SET:C117("SelectedSubRecords")

$0:=$n