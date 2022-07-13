//%attributes = {}
// _______
// Method: edi_SetOutboxContent   ( ) ->
// By: Mel Bohince @ 04/23/20, 14:14:56
// Description
// save the blob, orda doesn't like blobs I'm told
// ----------------------------------------------------
C_LONGINT:C283($1; $3; $0)
C_POINTER:C301($2)

READ WRITE:C146([edi_Outbox:155])
QUERY:C277([edi_Outbox:155]; [edi_Outbox:155]ID:1=$1)

If (Records in selection:C76([edi_Outbox:155])=1)
	If (fLockNLoad(->[edi_Outbox:155]))
		SET BLOB SIZE:C606([edi_Outbox:155]Content:3; 0)
		TEXT TO BLOB:C554($2->; [edi_Outbox:155]Content:3; UTF8 text without length:K22:17)
		[edi_Outbox:155]SentTimeStamp:4:=0  //ready to resend
		SAVE RECORD:C53([edi_Outbox:155])
		$0:=0
	Else 
		uConfirm("Outbox message "+String:C10($1)+" was locked, changes not saved."; "Dang"; "Ok")
		$0:=$3
	End if 
Else   //unchanged
	$0:=$3
End if 

UNLOAD RECORD:C212([edi_Outbox:155])
READ ONLY:C145([edi_Outbox:155])
