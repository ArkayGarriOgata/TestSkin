//%attributes = {}
//Method: Outbox_Dispatcher(msg;param1;param2)  102198  MLB
//see if there are any messages to send

C_TEXT:C284($msg; $1)
C_TEXT:C284(com_account_id; $2; $3)
C_LONGINT:C283($0; $err; $i; $numMail)  //return 0 for success
C_TIME:C306($docRef)

If (Count parameters:C259>0)
	$msg:=$1
Else 
	$msg:="show"
End if 

$0:=-1  //fail closed

Case of 
	: ($msg="toDisk")
		GOTO RECORD:C242([edi_Outbox:155]; Num:C11($2))
		BLOB TO DOCUMENT:C526($3; [edi_Outbox:155]Content:3)
		
	: ($msg="addBlob")
		zBlobLoad($2; Num:C11($3); "outbox")
		
	: ($msg="show")
		//<>PID_outbox:=ViewSetter (2;->[edi_Outbox])
		edi_Outbox_UI
		
	: ($msg="open")
		zwStatusMsg("COM"; "Opening Outbox")
		READ WRITE:C146([edi_Outbox:155])
		ARRAY LONGINT:C221(aRecordNumber; 0)
		ARRAY TEXT:C222(com_aMailBag; 0)
		ARRAY LONGINT:C221(com_aMailSent; 0)
		QUERY:C277([edi_Outbox:155]; [edi_Outbox:155]SentTimeStamp:4=0; *)
		QUERY:C277([edi_Outbox:155];  & ; [edi_Outbox:155]Com_AccountName:7=com_account_id)  //com_account
		ORDER BY:C49([edi_Outbox:155]; [edi_Outbox:155]Subject:5; >)
		SELECTION TO ARRAY:C260([edi_Outbox:155]; aRecordNumber; [edi_Outbox:155]Subject:5; com_aMailBag)
		$numMail:=Size of array:C274(com_aMailBag)
		
		ARRAY LONGINT:C221(com_aMailSent; $numMail)
		If ($numMail>0)
			zwStatusMsg("EDI"; String:C10($numMail)+" messages to send")
			$0:=0
		Else 
			$0:=-15201
			COM_ErrorEncountered(0; $0; "No messages to send")
		End if 
		REDUCE SELECTION:C351([edi_Outbox:155]; 0)
		
	: ($msg="close")
		zwStatusMsg("COM"; "Closing Outbox")
		READ WRITE:C146([edi_Outbox:155])
		$problem:=False:C215
		For ($i; 1; Size of array:C274(aRecordNumber))
			GOTO RECORD:C242([edi_Outbox:155]; aRecordNumber{$i})
			If (Records in selection:C76([edi_Outbox:155])=1)
				[edi_Outbox:155]SentTimeStamp:4:=com_aMailSent{$i}
				SAVE RECORD:C53([edi_Outbox:155])
				
			Else 
				$problem:=True:C214
				COM_ErrorEncountered(1; $0; "Couldn't mark message "+com_aMailBag{$i}+" as sent.")
				DELAY PROCESS:C323(Current process:C322; 60)
			End if 
		End for 
		FLUSH CACHE:C297
		
		If ($problem)
			$0:=-15202
			COM_ErrorEncountered(1; $0; "Couldn't mark some messages as sent.")
		Else 
			$0:=0
		End if 
		
		REDUCE SELECTION:C351([edi_Outbox:155]; 0)
		
	Else   //message not understood
		TRACE:C157
End case 