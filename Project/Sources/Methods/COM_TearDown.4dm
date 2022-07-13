//%attributes = {}
//Method: COM_TearDown()  091498  MLB
//release the connection to the host

zwStatusMsg("COM"; "Shutting down")

C_LONGINT:C283($err)

$err:=0

If (com_controlStream#0)
	$reply:=COM_SendCmd(com_controlStream; "QUIT"+eol)  // send Logout  
	$err:=TCP_Close(com_controlStream)
	
	If ($err#0)
		COM_ErrorEncountered(0; $err; "Couldn't release the control streams properly.")
	End if 
End if 

If (com_dataStream#0)
	$err:=TCP_Close(com_dataStream)
	If ($err#0)
		COM_ErrorEncountered(0; $err; "Couldn't release the data streams properly.")
	End if 
End if 

com_controlStream:=0
com_dataStream:=0
<>FTP_PID:=0

If (com_Trace)
	//CLOSE WINDOW
End if 