//%attributes = {}
//Method: COM_OpenConnection()  091498  MLB
//connect to the server

zwStatusMsg("COM"; "Starting Session: Connecting")

C_LONGINT:C283($0; $connectionState; $reply)  //return 0 for success

$0:=-1  //fail closed

$err:=TCP_Open(com_server; 21; com_controlStream; 0)  // open command stream, 30 sec timeout

zwStatusMsg("COM"; "Starting Session: Open id: "+String:C10(com_controlStream)+" State: "+String:C10(com_state))

If (com_controlStream#0)
	zwStatusMsg("COM"; "Starting Session: Connection id: "+String:C10(com_controlStream))
	
	$connectionState:=COM_WaitForState(com_controlStream; 8; 120)
	zwStatusMsg("COM"; "Starting Session: Connection id: "+String:C10(com_controlStream)+" State: "+String:C10(com_state))
	
	If ($connectionState=8)  // log on to FTP server established
		$reply:=COM_WaitForReply(com_controlStream)
		If (($reply>=100) & ($reply<=299))
			zwStatusMsg("COM"; "Connected: "+String:C10(com_controlStream)+" State: "+String:C10(com_state))
			$0:=0
		Else 
			$0:=-15003
			COM_ErrorEncountered(2; $0; "Host didn't acknoledge the connection.")
		End if 
		
	Else 
		$0:=-15002
		COM_ErrorEncountered(2; $0; "Couldn't establish a connection to the host.")
	End if 
	
Else 
	$0:=-15001
	COM_ErrorEncountered(2; $0; "Couldn't open a connectin to the host.")
End if 
