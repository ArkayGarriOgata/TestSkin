//%attributes = {}
// _______
// Method: EDI_clearBlobs   ( ) ->
// By: MelvinBohince @ 01/19/22, 16:25:13
// Description
// to save some record space by zero'g blobs a month or older?
// do not touch the content text fields
// ----------------------------------------------------
C_DATE:C307($dateToPreventClearing)
C_LONGINT:C283($timeStampToPreventClearing; $inboxBytesUsed; $outboxBytesUsed)
C_TEXT:C284($msg)
$msg:=""
utl_LogfileServer("aMs"; "Start")

If (True:C214)  //clear inbox
	
	$inboxBytesUsed:=0
	$dateToPreventClearing:=Add to date:C393(Current date:C33; 0; -1; 0)  //keep if less than a month old
	QUERY BY FORMULA:C48([edi_Inbox:154]; ([edi_Inbox:154]Date_Received:9<$dateToPreventClearing) & (BLOB size:C605([edi_Inbox:154]Content:3)>0))  //
	
	While (Not:C34(End selection:C36([edi_Inbox:154])))
		$inboxBytesUsed:=$inboxBytesUsed+BLOB size:C605([edi_Inbox:154]Content:3)
		
		SET BLOB SIZE:C606([edi_Inbox:154]Content:3; 0)
		SAVE RECORD:C53([edi_Inbox:154])
		
		NEXT RECORD:C51([edi_Inbox:154])
	End while 
	
	$inboxBytesUsed:=$inboxBytesUsed/1000000
	$msg:="intbox had: "+String:C10($inboxBytesUsed; "###,###")+"Mb, "
	
	BEEP:C151
End if 

If (True:C214)  //clear outbox
	
	$outboxBytesUsed:=0
	$timeStampToPreventClearing:=TSTimeStamp($dateToPreventClearing)
	QUERY BY FORMULA:C48([edi_Outbox:155]; ([edi_Outbox:155]SentTimeStamp:4<$timeStampToPreventClearing) & (BLOB size:C605([edi_Outbox:155]Content:3)>0))
	
	While (Not:C34(End selection:C36([edi_Outbox:155])))
		$outboxBytesUsed:=$outboxBytesUsed+BLOB size:C605([edi_Outbox:155]Content:3)
		
		SET BLOB SIZE:C606([edi_Outbox:155]Content:3; 0)
		SAVE RECORD:C53([edi_Outbox:155])
		
		NEXT RECORD:C51([edi_Outbox:155])
	End while 
	
	$outboxBytesUsed:=$outboxBytesUsed/1000000
	$msg:=$msg+"outbox had: "+String:C10($outboxBytesUsed; "###,###")+"Mb "
	
	BEEP:C151
End if 

ALERT:C41($msg)
utl_LogfileServer("aMs"; $msg)
