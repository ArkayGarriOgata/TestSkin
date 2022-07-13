Case of 
	: (Form event code:C388=On Load:K2:1)
		t1:=TS2String([edi_Outbox:155]SentTimeStamp:4)
		
	: (Form event code:C388=On Close Box:K2:21)
		bDone:=1
		CANCEL:C270
		
End case 
