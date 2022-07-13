//%attributes = {}
//Method: COM_GetMessages(->directoryListingArray)  091498  MLB
//download any waiting messages

zwStatusMsg("COM"; "Downloading Messages")

C_LONGINT:C283($0; $err; $i; $lines; $numMail; $replyNum)  //return 0 for success
C_TEXT:C284($time)
C_LONGINT:C283(lFileSize)
C_POINTER:C301($1; $ptrArrManifest)

lFileSize:=0


$0:=-1  //fail closed
//*Parse out file names
$ptrArrManifest:=$1
$lines:=Size of array:C274($ptrArrManifest->)

ARRAY TEXT:C222(com_aMailBag; 0)
ARRAY TEXT:C222(com_aMailBag; $lines)

$numMail:=0
utl_Trace
For ($i; 1; $lines)
	lFileSize:=0
	If (Length:C16($ptrArrManifest->{$i})>=com_fileNamePos)
		If (Position:C15("stercomm.com"; com_server)>0)  //(com_server="sciftp.commerce.stercomm.com") | (com_server="209.95.224.135") | (com_server="sciftpgw.commerce.stercomm.com")
			$dirLine:=$ptrArrManifest->{$i}
			$statCode:=Substring:C12($dirLine; 1; 10)
			If (Position:C15("T"; $statCode)=0)  //the total line or already recieved
				If (Position:C15("C"; $statCode)=0)  //we sent this one  
					$typeField:=Substring:C12($dirLine; 11; 4)
					$mailSlot:=Substring:C12($dirLine; 15; 10)
					$batchNumber:=Substring:C12($dirLine; com_fileNamePos; 7)
					$batchCount:=Substring:C12($dirLine; 33; 9)
					lFileSize:=Num:C11($batchCount)
					$procDate:=Substring:C12($dirLine; 42; 7)
					$procTime:=Substring:C12($dirLine; 49; 6)
					$batchID:=Substring:C12($dirLine; 55)
					If (True:C214)  //normal naming
						$fileName:="#"+$batchNumber
					Else   //alternate method of naming
						$fileName:=Substring:C12($ptrArrManifest->{$i}; 55)+".#"+Substring:C12($ptrArrManifest->{$i}; com_fileNamePos; 7)
					End if 
					$numMail:=$numMail+1
					com_aMailBag{$numMail}:=$fileName
				End if   //C
			End if   //T
			
		Else   //arkay
			$fileName:=Substring:C12($ptrArrManifest->{$i}; com_fileNamePos)
			$numMail:=$numMail+1
			com_aMailBag{$numMail}:=$fileName
		End if 
	End if   //long enough
End for 
ARRAY TEXT:C222(com_aMailBag; $numMail)

If ($numMail>0)
	zwStatusMsg("COM"; String:C10($numMail)+" new Messages")
	//*set up mode  
	If (True:C214)  //(com_server="sciftp.commerce.stercomm.com") | (com_server="209.95.224.135") | (com_server="sciftpgw.commerce.stercomm.com")
		$replyNum:=COM_SendCmd(com_controlStream; "TYPE A"+eol)
		
	Else 
		$replyNum:=COM_SendCmd(com_controlStream; "MACB E"+eol)
		$replyNum:=COM_SendCmd(com_controlStream; "TYPE I"+eol)
		$replyNum:=COM_SendCmd(com_controlStream; "MODE S"+eol)
	End if 
	
	C_BLOB:C604($blobReceived; $blobAll)
	For ($i; 1; $numMail)  //Retreive the mail  
		SET BLOB SIZE:C606($blobReceived; 0)
		SET BLOB SIZE:C606($blobAll; 0)
		$fileName:=com_aMailBag{$i}
		$short_fname:=$fileName
		$time:=Substring:C12(String:C10(Current time:C178; HH MM SS:K7:1); 4; 5)
		zwStatusMsg("COM"; "Retrieving file: "+String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+" @"+$time)
		com_SessionLog:=com_SessionLog+Char:C90(13)+"Retrieving file: "+String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+Char:C90(13)
		//TEXT TO BLOB(Char(13)+"Retrieving file: "+String($i)+"/"+String($numMail)+" "+$fileName+Char(13);xcom_SessionLog;Text without length ;*)
		
		If (com_Trace)
			MESSAGE:C88(Char:C90(13)+"Retrieving file: "+String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+Char:C90(13))
		End if 
		
		C_LONGINT:C283($lNumTries)
		$lNumTries:=0
		C_BOOLEAN:C305($bSuccessStream)
		$bSuccessStream:=False:C215
		
		Repeat 
			$err:=COM_OpenDataStream
			If ($err=0)
				$bSuccessStream:=True:C214
				$lNumTries:=0
				
				utl_Trace
				bDontTimeOut:=True:C214
				$replyNum:=COM_SendCmd(com_controlStream; "RETR "+$fileName+eol)
				$fileName:=<>inboxFolderPath+$fileName
				
				If (($replyNum>=100) & ($replyNum<=299))
					$err:=COM_WaitForState(com_dataStream; 8; 36)
					
					If ($err=8)  //established
						utl_Trace
						$TimedOut:=COM_TimeOut
						
						C_LONGINT:C283($srcpos; $dstpos)
						Repeat 
							$err:=TCP_ReceiveBLOB(com_dataStream; $blobReceived)  // receive file, no
							$err:=TCP_State(com_dataStream; $state)
							$srcpos:=0
							$dstpos:=BLOB size:C605($blobAll)
							COPY BLOB:C558($blobReceived; $blobAll; $srcpos; $dstpos; BLOB size:C605($blobReceived))
						Until ($state=0) | ($err#0)
						BLOB TO DOCUMENT:C526($fileName; $blobAll)
						
						If ($err=0)
							zwStatusMsg("COM"; "Putting file: "+String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+" in the Inbox")
							Inbox_Dispatcher("addBlob"; $fileName; String:C10(com_startedAt))
							REDUCE SELECTION:C351([edi_Inbox:154]; 0)
							
							com_SessionLog:=com_SessionLog+"  -- OK --"+Char:C90(13)
							//TEXT TO BLOB("  -- OK --"+Char(13);xcom_SessionLog;Text without length ;*)
							
							$0:=0
							
							If (com_Trace)
								MESSAGE:C88("  -- OK --"+Char:C90(13))
							End if 
							
							If (com_account="e-Com")  //need to delete the file on the ftp server so not re-fetched
								$replyNum:=COM_SendCmd(com_controlStream; "DELE "+$short_fname+eol)
								If (($replyNum>=100) & ($replyNum<=299))
									$err:=COM_WaitForState(com_controlStream; 8; 36)
									utl_Trace
									$TimedOut:=COM_TimeOut
									If ($err=0)
										zwStatusMsg("COM"; "Deleted file: "+$short_fname+" from e-Com server")
										com_SessionLog:=com_SessionLog+"  -- DELETE OK --"+Char:C90(13)
										If (com_Trace)
											MESSAGE:C88("  -- DELETE OK --"+Char:C90(13))
										End if 
									End if 
								End if   //replynum
							End if   //ecom
							
						Else   //didn't recv
							com_SessionLog:=com_SessionLog+"   ** FAILED **"+Char:C90(13)
							//TEXT TO BLOB("   ** FAILED **"+Char(13);xcom_SessionLog;Text without length ;*)
							
							$0:=-15014
							If (com_Trace)
								MESSAGE:C88("    ** FAILED **"+Char:C90(13))
							End if 
							$i:=$i+$numMail  //break
						End if   //recv
						
						$err:=TCP_State(com_dataStream; $state)
						If ($state#0)
							If (com_dataStream#0)
								$err:=TCP_Close(com_dataStream)
								com_dataStream:=0
								<>FTP_PID:=0
							End if 
						End if 
						
					Else 
						$0:=-15013
						COM_ErrorEncountered(2; $0; "Couldn't open a stream to receive file.")
						$i:=$i+$numMail  //break
					End if   //no data stream established
					
				Else 
					$0:=-15012
					COM_ErrorEncountered(2; $0; "Couldn't open a stream to receive file.")
					$i:=$i+$numMail  //break      
				End if   //retr command successful
				
			Else 
				$lNumTries:=$lNumTries+1
			End if   //retr command successful  
		Until (($bSuccessStream) | ($lNumTries>=2) | (Windows Alt down:C563))
		
		C_BOOLEAN:C305(bErrorAlert)
		bErrorAlert:=False:C215
		
		If (Not:C34($bSuccessStream))
			//$0:=-15011
			bErrorAlert:=True:C214
			COM_ErrorEncountered(2; $0; "Couldn't open a stream to receive file.")
			//$i:=$i+$numMail  `don't break - try other files    
		End if 
		
		If (Windows Alt down:C563)
			bErrorAlert:=True:C214
			$i:=$i+$numMail  //break 
		End if 
		
	End for   //mail file
	SET BLOB SIZE:C606($blobReceived; 0)
	SET BLOB SIZE:C606($blobAll; 0)
	FLUSH CACHE:C297
	
Else 
	com_SessionLog:=com_SessionLog+"NO MAIL"+Char:C90(13)
	//TEXT TO BLOB("NO MAIL"+Char(13);xcom_SessionLog;Text without length ;*)
	$0:=-15010
	COM_ErrorEncountered(0; $0; "No mail to get.")
End if 