//%attributes = {}
// Method: DOC_removeLink () -> 
// ----------------------------------------------------
// by: mel: 09/09/04, 12:50:31
// ----------------------------------------------------

C_LONGINT:C283($0)

$0:=-1
READ WRITE:C146([x_linked_documents:133])
GOTO RECORD:C242([x_linked_documents:133]; $1)
If (Records in selection:C76([x_linked_documents:133])=1)
	If (fLockNLoad(->[x_linked_documents:133]))
		DELETE RECORD:C58([x_linked_documents:133])
		$0:=0
	Else 
		BEEP:C151
		ALERT:C41("Record locked, could not remove link.")
	End if 
Else 
	BEEP:C151
	ALERT:C41("Record not found, could not remove link.")
End if 

READ ONLY:C145([x_linked_documents:133])
REDUCE SELECTION:C351([x_linked_documents:133]; 0)