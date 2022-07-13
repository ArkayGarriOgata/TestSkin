//%attributes = {}
//Method: COM_StartSession()  091498  MLB
//Connect to VAN host and Retrieve and Send Msgs
// Modified by: Mel Bohince (12/9/14) add option for Expandrive
// Modified by: Mel Bohince (9/9/21) comment unused sections
// Modified by: MelvinBohince (1/26/22) make changes for StrongSync
// Modified by: MelvinBohince (2/3/22) add pref for path that StrongSync uses
// Modified by: MelvinBohince (2/23/22) if local, don't try to delete

C_TEXT:C284($1)
C_BOOLEAN:C305(<>bAutomatic)  //variable for dialog-less connections
C_TEXT:C284(com_account)

// <>FTP_PID:=0  //for debugging aborts

If (Count parameters:C259=0)  //init the process
	If (<>FTP_PID=0)  //if we're not already connected
		<>FTP_PID:=New process:C317("COM_StartSession"; <>lBigMemPart; "FTP_Client"; "FTP Client")
		If (False:C215)
			COM_StartSession
		End if 
		zwStatusMsg("COM"; "Starting Communication Session")
	Else 
		If (Application type:C494#4D Server:K5:6)
			uConfirm("A communications session is in progress.  Please try again later."; "OK"; "Help")
		End if 
	End if 
	
Else 
	C_BOOLEAN:C305($successfulLogin; $successfulGet; $successfulSend; com_usePassive)
	$successfulLogin:=False:C215
	$successfulGet:=False:C215
	$successfulSend:=False:C215
	C_LONGINT:C283(com_startedAt)
	
	If ((Application type:C494#4D Server:K5:6) & (Not:C34(<>bAutomatic)))
		utl_Trace
		SET MENU BAR:C67(<>DefaultMenu)
		NewWindow(340; 220; 0; 8; "Connect")  //600;350
		DIALOG:C40([edi_Inbox:154]; "MakeConnection_dio")  //set some prefs like cb1,cb2,cb3,com_account
		ARRAY TEXT:C222($atAccounts; 1)
		$atAccounts{1}:=com_account
		
	Else 
		//see a version of ams before 1/26/2022 to see the code that was commented out
	End if   //if not server
	
	bErrorAlert:=False:C215
	
	com_startedAt:=TSTimeStamp
	
	If (Position:C15(Substring:C12(com_account; 1; 5); " Expan Local Stron")=0)  //use the original method// Modified by: MelvinBohince (1/26/22) make changes for StrongSync
		//see a version of ams before 1/26/2022 to see the code that was commented out
		
	Else   //using ExpanDrive/StrongSync for the ftp portion   // Modified by: MelvinBohince (1/26/22) make changes for StrongSync
		If (OK=1)
			COM_SetUp(com_account)
			COM_ExpanDrive
			// Modified by: Mel Bohince (2/3/15) for some reason the delete doc as being read doesn't work, so repeat here
			ARRAY TEXT:C222($aVolumes; 0)
			ARRAY TEXT:C222($aDocuments; 0)
			
			If (Position:C15("Local"; com_account)=0)  //local // Modified by: MelvinBohince (2/23/22) 
				
				VOLUME LIST:C471($aVolumes)
				$hit:=Find in array:C230($aVolumes; "van-ftp.nubridges.net")
				If ($hit>-1)
					$path:=$aVolumes{$hit}+<>DELIMITOR+"outbox"
					DOCUMENT LIST:C474($path; $aDocuments; Absolute path:K24:14+Ignore invisible:K24:16)
					$numMail:=Size of array:C274($aDocuments)
					If ($numMail>0)
						
						CONFIRM:C162("Attempt to delete the "+String:C10($numMail)+" documents in van-ftp.nubridges.net?"; "Delete"; "Cancel")
						If (ok=1)
							For ($i; 1; $numMail)
								$filename:=$aDocuments{$i}
								util_deleteDocument($fileName)
							End for 
						End if 
						
					Else 
						ALERT:C41("Nothing in volume:"+"van-ftp.nubridges.net")
					End if 
					
				Else 
					ALERT:C41("Couldn't find volume:"+"van-ftp.nubridges.net")
				End if 
			End if   //not local
			
		End if 
	End if 
	CLOSE WINDOW:C154
	<>FTP_PID:=0
	
	//Lastly, let's look to see if there are records that need updated with AMS data
End if 
