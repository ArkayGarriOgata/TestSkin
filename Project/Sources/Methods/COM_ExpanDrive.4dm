//%attributes = {}
// Method: COM_ExpanDrive ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 12/09/14, 13:37:07
// ----------------------------------------------------
// Description
// grab edi messages off of an ExpanDrive volume
//
// ----------------------------------------------------
// Modified by: Mel Bohince (9/9/21) always use the edi_Com_Account record's path
// Modified by: MelvinBohince (1/26/22) strongsync hint
// Modified by: MelvinBohince (2/3/22) use Library:CloudStorage path for strongSync connection & the ediCOMAccount pref
// Modified by: MelvinBohince (2/23/22) test for local, instead of True
// Modified by: MelvinBohince (3/31/22) move prior sessions files to the archive folder, undo the StrongSync cloud storage change

//Check a directory listing of the volume
C_TEXT:C284($r)
$r:=Char:C90(13)
com_SessionLog:=com_account+":"+$r
ARRAY TEXT:C222($aVolumes; 0)
ARRAY TEXT:C222($aDocuments; 0)
C_BOOLEAN:C305(bErrorAlert)
bErrorAlert:=False:C215

If (Position:C15("ExpanDrive"; com_account)>0)  // Modified by: MelvinBohince (2/3/22) Normal ExpanDrive
	VOLUME LIST:C471($aVolumes)
	$hit:=Find in array:C230($aVolumes; com_server)
	
Else   // Modified by: MelvinBohince (3/31/22) restore normal local disk path
	
	EDI_OutboxHouseKeeping  // Modified by: MelvinBohince (3/31/22) move prior sessions files to the archive folder
	
	$hit:=1  //going to create it directly from the preference
	$usersFolder:=System folder:C487(Documents folder:K41:18)  //Macintosh HD:Users:mel:Documents:  find the user's home dir
	ARRAY TEXT:C222($aVolumes; $hit)
	$aVolumes{$hit}:=$usersFolder+com_path  //pref path should be like ~/doc/ams_doc/EDI_Outbox
End if 

If ($hit>-1)
	If (cb1=1)  //get mail
		//DOCUMENT LIST($aVolumes{$hit}+<>DELIMITOR+com_DirData;$aDocuments)
		If (Position:C15("Local"; com_account)=0)
			$path:=$aVolumes{$hit}+<>DELIMITOR+com_DirData
		Else 
			$path:=util_DocumentPath+com_DirData
		End if 
		DOCUMENT LIST:C474($path; $aDocuments; Absolute path:K24:14+Ignore invisible:K24:16)
		$numMail:=Size of array:C274($aDocuments)
		//$numMail:=3
		com_SessionLog:=com_SessionLog+String:C10($numMail)+" Messages waiting"+$r
		If (com_Trace)
			MESSAGE:C88(String:C10($numMail)+" Messages waiting:"+$r)
		End if 
		
		For ($i; 1; $numMail)
			com_SessionLog:=com_SessionLog+String:C10($i)+") "+$aDocuments{$i}+$r
			If (com_Trace)
				MESSAGE:C88(String:C10($i)+") "+$aDocuments{$i}+$r)
			End if 
		End for 
		com_SessionLog:=com_SessionLog+$r
		///////////////
		///////////////
		///////////////
		//For each file in directory, load it into a blob in the inbox
		C_BLOB:C604(theBlob)
		For ($i; 1; $numMail)  //Retreive the mail 
			SET BLOB SIZE:C606(theBlob; 0)
			Document:=""
			//$fileName:=$aVolumes{$hit}+<>DELIMITOR+com_DirData+<>DELIMITOR+$aDocuments{$i}
			$fileName:=$aDocuments{$i}
			$time:=Substring:C12(String:C10(Current time:C178; HH MM SS:K7:1); 4; 5)
			zwStatusMsg("COM"; "Retrieving file: "+String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+" @"+$time)
			com_SessionLog:=com_SessionLog+$r+"Retrieve: "+String:C10($i)+"/"+String:C10($numMail)+" "+$aDocuments{$i}+$r
			
			If (com_Trace)
				MESSAGE:C88(Char:C90(13)+"Retrieve: "+String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+Char:C90(13))
			End if 
			
			$docRef:=Open document:C264($fileName)
			CLOSE DOCUMENT:C267($docRef)
			DOCUMENT TO BLOB:C525(Document; theBlob)
			
			If (ok=1)
				zwStatusMsg("COM"; "Save: "+String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+" in the Inbox")
				com_SessionLog:=com_SessionLog+"Save: "+String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+" in the Inbox"
				CREATE RECORD:C68([edi_Inbox:154])
				[edi_Inbox:154]ID:1:=Sequence number:C244([edi_Inbox:154])
				[edi_Inbox:154]Path:2:=Substring:C12($fileName; 1; 10)+"..."+HFSShortName($fileName)
				[edi_Inbox:154]Content:3:=theBlob
				[edi_Inbox:154]Date_Received:9:=Current date:C33
				[edi_Inbox:154]Received:5:=TSTimeStamp
				[edi_Inbox:154]Mapped:6:=0
				SAVE RECORD:C53([edi_Inbox:154])
				REDUCE SELECTION:C351([edi_Inbox:154]; 0)
				com_SessionLog:=com_SessionLog+"  -- OK --"+$r
				
				If (Position:C15(Substring:C12(com_account; 1; 5); " Expan  ")>0)
					com_SessionLog:=com_SessionLog+"Delete: "+String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+" from server"+$r
					If (com_Trace)
						MESSAGE:C88(Char:C90(13)+"Delete: "+String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+Char:C90(13))
					End if 
					util_deleteDocument($fileName)
					
				Else   //local
					com_SessionLog:=com_SessionLog+"Move: "+String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+" from server"+$r
					If (com_Trace)
						MESSAGE:C88(Char:C90(13)+"Move: "+String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+Char:C90(13))
					End if 
					$dst:=util_DocumentPath+"EDI_Archive:"+HFSShortName($fileName)
					MOVE DOCUMENT:C540($fileName; $dst)
				End if 
				
			Else   //no blob for you
				zwStatusMsg("FAIL"; "Save: "+String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+" in the Inbox")
				com_SessionLog:=com_SessionLog+"Failed Save: "+String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+" in the Inbox"
				bErrorAlert:=True:C214
			End if 
			
		End for   //mail file
		
		SET BLOB SIZE:C606(theBlob; 0)
		
	End if   //get mail
	
	
	///////////////
	///////////////
	///////////////
	If (cb2=1)  //send messages
		
		If (Outbox_Dispatcher("open")=0)  //somthing to send
			$numMail:=Size of array:C274(com_aMailBag)
			If (com_Trace)
				MESSAGE:C88($r+String:C10($numMail)+" messages to send"+$r)
			End if 
			com_SessionLog:=com_SessionLog+$r+"///////////////"+$r+"///////////////"+$r+"///////////////"+$r+String:C10($numMail)+" messages to send"+$r
			$sessionTime:=TSTimeStamp
			For ($i; 1; $numMail)  //Sending the mail  
				com_aMailSent{$i}:=-1  //pessimistic
				If (Position:C15("810"; com_aMailBag{$i})>0)  // Modified by: Mel Bohince (8/24/17) 
					$fileName:=com_aMailBag{$i}+".x12"
				Else 
					$fileName:=com_aMailBag{$i}+".edifact"
				End if 
				
				GOTO RECORD:C242([edi_Outbox:155]; aRecordNumber{$i})
				
				zwStatusMsg("SEND"; String:C10($i)+"/"+String:C10($numMail)+" "+$fileName)
				com_SessionLog:=com_SessionLog+"Sending file: "+$fileName+$r
				
				If (com_Trace)
					MESSAGE:C88(Char:C90(13)+"Sending file: "+$fileName+Char:C90(13))
				End if 
				
				
				C_LONGINT:C283($lBlobSize)
				$lBlobSize:=BLOB size:C605([edi_Outbox:155]Content:3)
				// Modified by: Mel Bohince (9/9/21) change to True, use the edi_COM_Account rec info
				// Modified by: MelvinBohince (2/23/22) test for local, instead of True
				If (Position:C15("Local"; com_account)=0)  //(Position(Substring(com_account;1;5);" Expan  ")>0)
					$path:=$aVolumes{$hit}+<>DELIMITOR+com_DirRpts
					
				Else   // Modified by: MelvinBohince (2/23/22)  //local, uncomment
					$path:=util_DocumentPath+com_DirRpts
				End if 
				BLOB TO DOCUMENT:C526($path+<>DELIMITOR+$fileName; [edi_Outbox:155]Content:3)
				If (ok=1)
					com_aMailSent{$i}:=$sessionTime
				End if 
				zwStatusMsg("SEND"; String:C10($i)+"/"+String:C10($numMail)+" "+$fileName+" closing")
				
				
				
			End for   //mail file
			
			
			Outbox_Dispatcher("close")
			
		End if   //something to send
	End if   //requesting to send
	
	///////////////
	///////////////
	///////////////
	//Do the normal mapping
	//*Save/Show session log
	If (Length:C16(com_SessionLog)>5)  //something happened
		//Inbox_Dispatcher ("Add";"SESSION LOG: "+zTS2String (com_startedAt);com_SessionLog)
		Inbox_Dispatcher("AddSessionBlob"; "SESSION LOG: "+TS2String(com_startedAt))
		REDUCE SELECTION:C351([edi_Inbox:154]; 0)
		com_SessionLog:=""
		Inbox_Dispatcher("Map")  //*map session log and reports    
		//Inbox_Dispatcher ("Show")  `($startedAt)
		zwStatusMsg("COM"; "Communication Session finished, check the Inbox")
		Inbox_Dispatcher("Notify"; "New Mail")
		
		BEEP:C151
	End if 
	
	
Else   //target volume not found
	uConfirm("Launch ExpanDrive or StrongSync and make the connection."; "Ok"; "Cancel")  // Modified by: MelvinBohince (1/26/22) strongsync hint
End if   //target volume not found
