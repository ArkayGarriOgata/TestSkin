//%attributes = {}
//Method: COM_OpenDataStream()  091498  MLB
//open a stream for data transfers
//•120298  MLB  add passive option

C_LONGINT:C283($0; $err; $replyNum; $localIPaddr)  //return 0 for success
C_LONGINT:C283($localPort; $remotePort; com_dataStream)
C_TEXT:C284($Command)

$0:=-1  //fail closed
com_dataStream:=0

utl_Trace

If (com_usePassive)
	$0:=COM_OpenPassivePort(->com_dataStream)  //let server setup the port
	
Else   //client controlled port
	$err:=TCP_Listen($remoteIPaddr; $localPort; $remotePort; 60; com_dataStream)  // open transfer stream, auto sel
	
	If (com_dataStream#0)
		
		$Command:="PORT "+com_LocalAddress+","+String:C10($localPort\256)+","+String:C10($localPort%256)+eol
		$replyNum:=COM_SendCmd(com_controlStream; $Command)  // send PORT command
		If (($replyNum>=100) & ($replyNum<=299))
			$0:=0
			
		Else 
			$0:=-15666
			COM_ErrorEncountered(2; $0; "Could not negoatiate a data port."+Char:C90(13)+com_aReplyBuffer{Size of array:C274(com_aReplyBuffer)})
		End if 
		
	Else 
		$0:=-15006
		COM_ErrorEncountered(2; $0; "Couldn't prepare to receive data. ")
	End if 
End if 