//%attributes = {}
//Method: EDI_MapInboxMsg()  110698  MLB
//map an inbox record

C_BOOLEAN:C305($continue)
C_BLOB:C604(theBlob)
C_LONGINT:C283($err; $0)

$continue:=True:C214

If ($continue)
	SET BLOB SIZE:C606(theBlob; 0)
	theBlob:=[edi_Inbox:154]Content:3
	$err:=EDI_OpenEnvelope(->theBlob; [edi_Inbox:154]ID:1; [edi_Inbox:154]Received:5)
	
	Case of 
		: ($err=0)  //normal edi
			[edi_Inbox:154]Mapped:6:=TSTimeStamp
			SAVE RECORD:C53([edi_Inbox:154])
			
		: ($err>=1)  //report or log
			[edi_Inbox:154]ICN:4:="Log"
			[edi_Inbox:154]Mapped:6:=TSTimeStamp
			SAVE RECORD:C53([edi_Inbox:154])
	End case 
	
	SET BLOB SIZE:C606(theBlob; 0)
End if 

$0:=$err