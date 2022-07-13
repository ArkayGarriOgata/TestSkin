//%attributes = {}
//Method: COM_OpenPassivePort(->dataStreamRef)  -> err 120298  MLB
//let the host define the data stream's port

C_LONGINT:C283($0; $start; $end; $hi; $low; $host)
C_POINTER:C301($1)  //dataStreamRef
C_TEXT:C284($reply)
C_BOOLEAN:C305(bDontTimeOut)

$0:=-1  //fail closed
$1->:=0
com_PASV_ip:=""
com_PASV_port:=0
bDontTimeOut:=True:C214
$replyNum:=COM_SendCmd(com_controlStream; "PASV"+eol)  //* Request port from host
bDontTimeOut:=False:C215

utl_Trace

If (($replyNum>=200) & ($replyNum<=399))  //e.g. 227 Entering Passive mode ( 209,95,224,133,5,88 )  
	//first find which element has the right response we're looking for - we can get multiple back!
	C_LONGINT:C283($lElemToUse)
	$lElemToUse:=1
	
	For ($k; 1; Size of array:C274(com_aReplyBuffer))
		If (Position:C15("227"; com_aReplyBuffer{$k})>0)
			$lElemToUse:=$k
		End if 
	End for 
	
	//*   parse the ip address
	$reply:=com_aReplyBuffer{$lElemToUse}  //was 1
	$start:=Position:C15("("; $reply)+1
	$end:=Position:C15(")"; $reply)
	$reply:=Substring:C12($reply; $start; $end-$start)  // 209,95,224,133,5,88  
	
	$end:=Position:C15(","; $reply)-1
	com_PASV_ip:=String:C10(Num:C11(Substring:C12($reply; 1; $end)))+"."  //209.
	$reply:=Substring:C12($reply; $end+2)  //95,224,133,5,88 
	
	$end:=Position:C15(","; $reply)-1
	com_PASV_ip:=com_PASV_ip+String:C10(Num:C11(Substring:C12($reply; 1; $end)))+"."  //95.
	$reply:=Substring:C12($reply; $end+2)  //224,133,5,88 
	
	$end:=Position:C15(","; $reply)-1
	com_PASV_ip:=com_PASV_ip+String:C10(Num:C11(Substring:C12($reply; 1; $end)))+"."  //224.
	$reply:=Substring:C12($reply; $end+2)  //133,5,88 
	
	$end:=Position:C15(","; $reply)-1
	com_PASV_ip:=com_PASV_ip+String:C10(Num:C11(Substring:C12($reply; 1; $end)))  //133
	
	//*   parse the port
	$reply:=Substring:C12($reply; $end+2)  //5,88 
	$end:=Position:C15(","; $reply)
	$hi:=Num:C11(Substring:C12($reply; 1; $end-1))*256
	$low:=Num:C11(Substring:C12($reply; $end+1))
	com_PASV_port:=$hi+$low
	
	If (com_PASV_port#0) & (Length:C16(com_PASV_ip)>0)  //*Open stream to that port
		com_SessionLog:=com_SessionLog+" Opening connection to "+com_PASV_ip+":"+String:C10(com_PASV_port)+Char:C90(13)
		//TEXT TO BLOB(com_SessionLog;xcom_SessionLog;Text without length ;*)
		
		$err:=TCP_Open(com_PASV_ip; com_PASV_port; $pasvStream; 0)  // open command stream
		$1->:=$pasvStream
		
		If ($1->#0)  //*   Wait for stream to get established
			$connectionState:=COM_WaitForState($1->; 8; 36)  // wait connection with F
			$0:=0
			
		Else 
			$0:=-15779
			COM_ErrorEncountered(2; $0; "Couldn't open a passive connection to the host.")
		End if 
		
	Else 
		$0:=-15778
		COM_ErrorEncountered(2; $0; "Couldn't identify a passive connection to the host.")
	End if 
	
Else 
	$0:=-15777
	COM_ErrorEncountered(2; $0; "Couldn't setup Passive mode connection. ")
	//$replyNum:=COM_SendCmd (com_controlStream;"NOOP"+eol)  ` send assert machine tpye for streamwatcher
	//If (($replyNum>=200) & ($replyNum<=399))
	//zwStatusMsg ("COM";"Starting Session: Logged in and responding.")
	//End if 
End if 