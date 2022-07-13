//%attributes = {}
//Method: COM_LogOn()  091498  MLB
//open the account with the username and password with the host
//•120298  MLB find host type and current directory for streamwatcher

zwStatusMsg("COM"; "Starting Session: Logging on")

C_LONGINT:C283($0; $err; $replyNum)  //return 0 for success
C_TEXT:C284($reply)

$0:=-1  //fail closed

$replyNum:=COM_SendCmd(com_controlStream; "USER "+com_user+eol)  // send USER username  
If (($replyNum>=200) & ($replyNum<=399))
	
	$replyNum:=COM_SendCmd(com_controlStream; "PASS "+com_password+eol)  // send PASS password
	If (($replyNum>=200) & ($replyNum<=399))
		$0:=0
		$hosttype:=""
		$dir:=""
		zwStatusMsg("COM"; "Starting Session: Logged in. ")
		$replyNum:=COM_SendCmd(com_controlStream; "NOOP"+eol)  // send assert machine tpye for streamwatcher
		If (($replyNum>=200) & ($replyNum<=399))
			zwStatusMsg("COM"; "Starting Session: Logged in and responding.")
			com_SessionLog:=com_SessionLog+"Starting Session: Logged in and responding."+Char:C90(13)
		End if 
		
		$replyNum:=COM_SendCmd(com_controlStream; "PWD"+eol)  // send assert current directory for streamwatcher
		If (($replyNum>=200) & ($replyNum<=399))
			$dir:=Substring:C12(com_aReplyBuffer{1}; 4)
		End if 
		
		zwStatusMsg("COM"; "Starting Session: Logged in. "+$dir+" ")
		
		$replyNum:=COM_SendCmd(com_controlStream; "NOOP"+eol)  // send assert current directory for streamwatcher
		
	Else 
		$0:=-15005
		COM_ErrorEncountered(2; $0; "Password failed. "+Char:C90(13)+$reply)
	End if 
	
Else 
	$0:=-15004
	COM_ErrorEncountered(2; $0; "Username "+com_user+" failed. "+Char:C90(13)+$reply)
End if 