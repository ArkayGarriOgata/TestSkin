
CUT NAMED SELECTION:C334([edi_Outbox:155]; "hold")
USE SET:C118("UserSet")  // user selected to process
If (Records in set:C195("UserSet")>0)
	
	APPLY TO SELECTION:C70([edi_Outbox:155]; [edi_Outbox:155]SentTimeStamp:4:=0)
	
Else 
	uConfirm("Select the records to change."; "Ok"; "Help")
End if 

USE NAMED SELECTION:C332("hold")
