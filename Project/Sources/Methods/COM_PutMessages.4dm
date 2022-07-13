//%attributes = {}
//Method: COM_PutMessages()  091598  MLB
//upload any waiting messages

C_LONGINT:C283($0; $err; $i; $numMail; $replyNum; $sessionTime)  //return 0 for success
C_TEXT:C284($fileName; $ftpName)  //ftpName can't have colons!

$0:=-1  //fail closed
$sessionTime:=TSTimeStamp

zwStatusMsg("COM"; "Sending Messages")

If ((com_DirData#"/") & (com_DirData#""))
	$replyNum:=COM_SendCmd(com_controlStream; "CWD "+com_DirData+eol)  //set type to ascii  
	//DELAY PROCESS(Current process;60*10)  `give host time to process uploads from this session
End if 

//*set up mode  
Case of 
	: (com_server="sciftp.commerce.stercomm.com") | (com_server="209.95.224.135") | (com_server="sciftpgw.commerce.stercomm.com") | (com_server="bohince.com")
		$replyNum:=COM_SendCmd(com_controlStream; "TYPE A"+eol)
		
	: (com_server="ecomint.ecomtoday.com") | (com_server="216.127.135.91")
		$replyNum:=COM_SendCmd(com_controlStream; "TYPE A"+eol)
		
		$replyNum:=COM_SendCmd(com_controlStream; "CWD "+com_DirRpts+eol)  //cd rcv for sending files  
		
	Else   //
		$replyNum:=COM_SendCmd(com_controlStream; "MACB E"+eol)  // enable MacBinary
		
		$replyNum:=COM_SendCmd(com_controlStream; "TYPE I"+eol)
		
		$replyNum:=COM_SendCmd(com_controlStream; "MODE S"+eol)
End case 

utl_Trace
$numMail:=Size of array:C274(com_aMailBag)

If ($numMail>0)
	For ($i; 1; $numMail)  //Sending the mail  
		com_aMailSent{$i}:=-1
		$fileName:=com_aMailBag{$i}
		
		GOTO RECORD:C242([edi_Outbox:155]; aRecordNumber{$i})
		
		zwStatusMsg("SEND"; String:C10($i)+"/"+String:C10($numMail)+" "+$fileName)
		com_SessionLog:=com_SessionLog+Char:C90(13)+"Sending file: "+$fileName+Char:C90(13)
		
		If (com_Trace)
			MESSAGE:C88(Char:C90(13)+"Sending file: "+$fileName+Char:C90(13))
		End if 
		
		$err:=COM_OpenDataStream
		If ($err=0)
			
			C_LONGINT:C283($lBlobSize)
			$lBlobSize:=BLOB size:C605([edi_Outbox:155]Content:3)
			If ($lBlobSize>511)
				//Set to streamed mode: quote"SITE ASCII_RECSEP=NONE"
				//Set to nonstreamed mode: quote"SITE_ASCII_RECSEP=CRLF"
				//Return the current value of ASCII_RECSEP: quote "SITE ASCII_RECSEP"
				$replyNum:=COM_SendCmd(com_controlStream; "SITE ASCII_RECSEP=None "+eol)
			End if 
			
			$replyNum:=COM_SendCmd(com_controlStream; "STOR "+$fileName+eol)
			If (($replyNum>=100) & ($replyNum<=299))
				
				$err:=COM_WaitForState(com_dataStream; 8; com_delay)
				If ($err=8)  //established
					
					$err:=TCP_SendBLOB(com_dataStream; [edi_Outbox:155]Content:3)  // receive file, no
					
					If ($err>=0)
						zwStatusMsg("SEND"; String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+" closing")
						DELAY PROCESS:C323(Current process:C322; 2*com_delay)  //give a little extra time
						
						$err:=TCP_Close(com_dataStream)  // closing stream indicates EOF
						
						DELAY PROCESS:C323(Current process:C322; 2*com_delay)  //give a little extra time
						$replyNum:=COM_WaitForReply(com_controlStream)
						If (($replyNum>=100) & ($replyNum<=299))
							com_SessionLog:=com_SessionLog+"  -- OK --"+Char:C90(13)
							
							$0:=0
							com_aMailSent{$i}:=$sessionTime
							If (com_Trace)
								MESSAGE:C88("  -- OK --"+Char:C90(13))
							End if 
							
						Else 
							com_aMailSent{$i}:=-2
							com_SessionLog:=com_SessionLog+"  -- "+String:C10($replyNum)+" --"+Char:C90(13)
							
							If (com_Trace)
								MESSAGE:C88("  -- FAIL --"+Char:C90(13))
							End if 
						End if 
					Else   //didn't send
						DELAY PROCESS:C323(Current process:C322; com_delay)  //give a little extra time
						$err:=TCP_Close(com_dataStream)  // closing stream indicates EOF   
						
						com_SessionLog:=com_SessionLog+"   ** FAILED **"+Char:C90(13)
						
						$0:=-15104
						com_aMailSent{$i}:=$0
						COM_ErrorEncountered(1; $0; "Send file appears to have failed, better check online. "+String:C10($err))
						If (com_Trace)
							MESSAGE:C88("    ** FAILED **"+Char:C90(13))
						End if 
						$i:=$i+$numMail  //break
					End if   //recv
					
					If (com_dataStream#0)
						$err:=COM_WaitForState(com_dataStream; 12)  // wait for the stream to be closed by
						$err:=TCP_Close(com_dataStream)
					End if 
					
				Else 
					$0:=-15103
					com_aMailSent{$i}:=$0
					COM_ErrorEncountered(1; $0; "Couldn't open a stream to send file "+$fileName)
					$i:=$i+$numMail  //break
				End if   //no data stream established
				
			Else 
				$0:=-15102
				com_aMailSent{$i}:=$0
				COM_ErrorEncountered(1; $0; "Couldn't open a stream to send file "+$fileName)
				$i:=$i+$numMail  //break      
			End if   //retr command successful
			
		Else 
			$0:=-15101
			com_aMailSent{$i}:=$0
			COM_ErrorEncountered(1; $0; "Couldn't open a stream to send file "+$fileName)
			$i:=$i+$numMail  //break  
		End if 
	End for   //mail file
	
Else 
	com_SessionLog:=com_SessionLog+"NO MAIL IN OUTBOX"+Char:C90(13)
	
	$0:=-15100
	COM_ErrorEncountered(0; $0; "No mail to send.")
End if 

If ($0#0)
	$err:=Outbox_Dispatcher("close")
End if 