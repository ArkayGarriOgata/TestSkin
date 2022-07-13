//%attributes = {"publishedWeb":true}
//PM: EMAIL_Fetcher() -> 
//@author mlb - 4/13/01  15:17

C_LONGINT:C283(sessionID; msgCount; msgSize; msgAttachCount; $hdrDate; $hdrFrom; $hdrSubject; $i; $j)
C_TEXT:C284($t; $cr)
C_TEXT:C284($pathForScratchFiles; $tempFile)
C_TEXT:C284(emailSubject; emailBody; emailResponse; emailAttachmentPath; emailHeader)  //PUBLIC ELEMENTS
ARRAY LONGINT:C221(aLrecNo; 0)
ARRAY TEXT:C222(aEmailHeaderValue; 0; 0)
ARRAY TEXT:C222(aFieldName; 3)
ARRAY TEXT:C222(aKey; 0)
ARRAY TEXT:C222(aEmailAttachment; 0)
ARRAY TEXT:C222($actionRequested; 9)  // see also Email_Opt_Help

sessionID:=0
$hdrDate:=1
$hdrFrom:=2
$hdrSubject:=3

aFieldName{$hdrDate}:="Date:"
aFieldName{$hdrFrom}:="From:"
aFieldName{$hdrSubject}:="Subject:"

$actionRequested{1}:="Help"
$actionRequested{2}:="Subscriptions"
$actionRequested{3}:="Subscribe"
$actionRequested{4}:="Unsubscribe"
$actionRequested{5}:="New Users"
$actionRequested{6}:="AskMe"
$actionRequested{7}:="WEB RFQ"
$actionRequested{8}:="Patch"
$actionRequested{9}:="Abort"

$t:=Char:C90(9)
$cr:=Char:C90(13)

$pathForScratchFiles:=Temporary folder:C486  //Select folder
$tempFile:="tempEmailBody"
//$err:=POP3_SetPrefs ()
//: (POP3_Login ("mail.arkay.com";"mel.bohince";"n9tj9aun";1;sessionID)#0) 
Case of 
	: (POP3_Login(<>EMAIL_POP3_HOST; <>EMAIL_POP3_USERNAME; <>EMAIL_POP3_PASSWORD; 1; sessionID)#0)  //use IP address from HQ!
	: (POP3_BoxInfo(sessionID; msgCount; msgSize)#0)
	: (POP3_MsgLst(sessionID; 1; msgCount; aFieldName; aLrecNo; aKey; aEmailHeaderValue)#0)
	: (Size of array:C274(aEmailHeaderValue)=0)  //no mail waiting
		
	Else   //success
		For ($i; 1; Size of array:C274(aEmailHeaderValue{1}))
			<>fContinue:=True:C214
			emailAttachmentPath:=""
			emailHeader:=""
			$from:=aEmailHeaderValue{$hdrFrom}{$i}
			emailSubject:=aEmailHeaderValue{$hdrSubject}{$i}
			$dated:=aEmailHeaderValue{$hdrDate}{$i}
			zwStatusMsg("GET EMAIL"; $from+" "+emailSubject+" "+$dated)
			emailResponse:="404"  //
			emailBody:=""
			//utl_LogIt ("init")
			//utl_LogIt ($dated+$cr+$from+$cr+emailSubject+$cr+"#####"+$cr;0)
			
			If (Email_isRegisteredUser($from))
				$hit:=Find in array:C230($actionRequested; emailSubject)
				If ($hit>-1)
					util_deleteDocument($pathForScratchFiles+$tempFile)
					$err:=POP3_Download(sessionID; aLrecNo{$i}; 0; $pathForScratchFiles+$tempFile)
					If ($err=0)
						$err:=MSG_GetBody($pathForScratchFiles+$tempFile; 0; 32000; emailBody)
					End if 
					
					$err:=MSG_HasAttach($pathForScratchFiles+$tempFile; msgAttachCount)
					If ($err=0)
						If (msgAttachCount>0)
							//$err:=MSG_Extract ($pathForScratchFiles+$tempFile;1;$pathForScratchFiles
							//«;aEmailAttachment)
						End if 
					End if 
					//utl_LogIt (emailBody;0)
					//utl_LogIt ("show")
					//Else   `in memory
					//$err:=POP3_GetMessage (sessionID;aLrecNo{$i};0;32000;emailBody)
					//End if          
					
					Case of 
						: (emailSubject="WEB RFQ")
							$newfrom:=Email_Opt_WebRFQ
							If (Length:C16($newfrom)>0)
								$from:=$newfrom
							End if 
							
						: (emailSubject="AskMe")
							Email_Opt_AskMe
							
						: (emailSubject="Patch")
							Email_Opt_Patch
							
						: (emailSubject="Subscribe")
							Email_Opt_Subscribe($from)
							
						: (emailSubject="Unsubscribe")
							Email_Opt_Unsubscribe($from)
							
						: (emailSubject="Subscriptions")
							Email_Opt_Subscriptions
							
						: (emailSubject="Help")
							Email_Opt_Help
							
						: (emailSubject="New Users")
							Email_isRegisteredUser
							
						: (emailSubject="Abort")
							emailAbort:=True:C214
							emailResponse:="Email Daemon Abort sequence set at "+String:C10(4d_Current_time; HH MM SS:K7:1)
							
						Else   //action unkown
							emailResponse:="400"
							//utl_LogIt (emailBody;0)
							//utl_LogIt ("show")
							EMAIL_Sender("Usage Error"; ""; emailSubject+" was sent by "+$from; "mel.bohince@arkay.com"; emailAttachmentPath)
							
					End case 
					
					CREATE RECORD:C68([x_email_logs:101])
					[x_email_logs:101]ReceivedDate:1:=4D_Current_date
					[x_email_logs:101]ReceivedTime:2:=4d_Current_time
					[x_email_logs:101]EmailFrom:3:=$from
					[x_email_logs:101]EmailSubject:4:=emailSubject
					[x_email_logs:101]EmailBody:5:=emailBody
					[x_email_logs:101]CountAttachments:6:=msgAttachCount
					SAVE RECORD:C53([x_email_logs:101])
					UNLOAD RECORD:C212([x_email_logs:101])
					
					emailResponse:=emailResponse
					EMAIL_Sender("RE:"+emailSubject; ""; emailResponse; $from; emailAttachmentPath; ""; ""; emailHeader)
					
					$err:=POP3_Delete(sessionID; aLrecNo{$i}; aLrecNo{$i})  //-->Integer
					
					//CONFIRM("Delete "+emailSubject;"Keep";"Delete")
					//If (ok=1)
					//POP3_Reset   `ignor deletes
					//End if   
					
				Else   //illegal request
					emailResponse:="400"
				End if   //illegal request
				
			Else   //user not authorized
				emailResponse:="401"
			End if   //user not authorized
		End for   //each listed email
End case   //log in sequence

If (sessionID#0)
	$err:=POP3_Logout(sessionID)
End if 

//clean up
//utl_LogIt ("init")
emailResponse:=""
emailBody:=""
emailSubject:=""
emailAttachmentPath:=""
emailHeader:=""
ARRAY TEXT:C222(aFieldName; 0)
ARRAY LONGINT:C221(aLrecNo; 0)
ARRAY TEXT:C222(aKey; 0)
ARRAY TEXT:C222(aEmailHeaderValue; 0; 0)
util_deleteDocument($pathForScratchFiles+$tempFile)
zwStatusMsg("GET EMAIL"; "Complete")