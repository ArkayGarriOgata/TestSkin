//%attributes = {}
//Method: COM_GetDirectoryListing(directory)  091498  MLB
//see whats in the default directory

C_TEXT:C284($1)  //directory of interest
C_LONGINT:C283($err; $replyNum; $0)
C_TEXT:C284($reply)

$0:=-1  //fail closed

If (com_controlStream=0)
	$err:=COM_Openconnection
	$err:=COM_LogOn
End if 

If (Count parameters:C259=0)  //go get reports
	zwStatusMsg("COM"; "Reading remote mailbox")
	
	If ((com_DirData#"/") & (com_DirData#""))
		$replyNum:=COM_SendCmd(com_controlStream; "CWD "+com_DirData+eol)  //set type to ascii  
		//DELAY PROCESS(Current process;60*10)  `give host time to process uploads from this session
	End if 
	
Else 
	$replyNum:=COM_SendCmd(com_controlStream; "CWD "+$1+eol)  //set type to ascii  
	//zwStatusMsg ("COM";"Pausing 10 seconds so host may process uploads and report errors")
	//DELAY PROCESS(Current process;60*10)  `give host time to process uploads from this session
	zwStatusMsg("COM"; "Reading report mailbox")
End if 

$replyNum:=COM_SendCmd(com_controlStream; "TYPE A"+eol)  //set type to ascii

$err:=COM_OpenDataStream
If ($err=0)
	$replyNum:=COM_SendCmd(com_controlStream; "LIST"+eol)
	If (($replyNum>=100) & ($replyNum<=299))
		$connectionState:=COM_WaitForState(com_controlStream; 8; 36)  // wait for transfer stream t
		If ($connectionState=8)  //established
			$replyNum:=COM_WaitForReply(com_dataStream; 1)
			If (Size of array:C274(com_aReplyBuffer)>0)
				zwStatusMsg("COM"; String:C10(Size of array:C274(com_aReplyBuffer))+" items listed in remote mailbox")
				$0:=0
				
				If (TCP_State(com_dataStream; 0)#0)
					If (com_dataStream#0)
						$err:=TCP_Close(com_dataStream)
						<>FTP_PID:=0
					End if 
				End if 
				
			Else 
				$0:=-15009
				COM_ErrorEncountered(1; $0; "Directory list is empty."+Char:C90(13)+$reply)
			End if 
			
		Else 
			$0:=-15008
			COM_ErrorEncountered(2; $0; "Data stream could not be established.")
		End if 
		
	Else 
		$0:=-15007
		COM_ErrorEncountered(2; $0; "Couldn't get directory list. "+Char:C90(13)+$reply)
	End if 
	
End if 