//%attributes = {}
// ----------------------------------------------------
// User name (OS): MLB
// Date: 2/28/01
// ----------------------------------------------------
// Method: EMAIL_SenderOLD
// Description:
// Use stmp protocol to send a message
// EMAIL_Sender(subject;bodyTitle;body;distribution;attch;from)

//• mlb - 7/6/01  change err msg text
//• mel (4/13/05, 14:00:24) clear blanks in distribution list
// Modified by: Mel Bohince (1/21/16) give designer choice to send because smtp server rejects from home network
// Modified by: Garri Ogata (4/20/2020) by pass confirm in [UsSp] is in the title of Subject (see Subject has [UsSp])
// ----------------------------------------------------
// Modified by: Mel Bohince (7/15/21) server option for current date/time

C_TEXT:C284($bodyHdr; $body; $2; $3; $4; $distribList; $replyTo; $from)
C_TEXT:C284($subject; $attachmentPath; $5; $1; $6; $7; $8)
C_LONGINT:C283($msgId; $connectionId; $params; $tabPos; $len; $err)
C_TEXT:C284($t)
C_TEXT:C284($0)  // Optional, Added by: Mark Zinke (4/22/13) 

$t:=Char:C90(9)
$r:=Char:C90(13)
//*Defaults:
$subject:="*no subject*"
$distribList:="mel.bohince@arkay.com"
$bodyHdr:=""
$body:="no body"
$attachmentPath:=""
$header:=""
$from:=<>EMAIL_FROM
$pwd:=<>EMAIL_POP3_PASSWORD
$replyTo:=<>EMAIL_FROM  //<>EMAIL_REPLYTO
$cc:=""
//*Overrides:
$params:=Count parameters:C259
$SMTP_ID:=0

If ($params>=1)
	If (Length:C16($1)>0)
		$subject:=$1
	End if 
End if 

If ($params>=2)
	If (Length:C16($2)>0)
		$bodyHdr:=$2
	End if 
End if 

If ($params>=3)
	If (Length:C16($3)>0)
		$body:=$3
	End if 
End if 

If (Length:C16($bodyHdr)>0)  // Modified by: mlb (5/8/13) don't add unnecessary cr's
	$body:=$bodyHdr+$r+$r+$body  // Modified by: Mark Zinke (4/17/13) $bodyHdr moved before $body.
End if 


If ($params>=4)
	If (Length:C16($4)>1)
		$distribList:=$4
	End if 
End if 

$distribList:=Replace string:C233($distribList; $t; ",")
$distribList:=Replace string:C233($distribList; ",,"; ",")  // • mel (4/13/05, 14:00:24)
$len:=Length:C16($distribList)  //*parse distribution list
If ($distribList[[$len]]=",")  //make it end in a tab
	$distribList:=Substring:C12($distribList; 1; $len-1)
End if 

If ($params>=5)
	$attachmentPath:=$5
End if 

If ($params>=6)
	If (Length:C16($6)>0)
		$replyTo:=$6
	End if 
End if 

If ($params>=7)
	If (Length:C16($7)>0)
		//$from:=$7   // Modified by: Mel Bohince (3/9/20) override so that SMTP_Auth works
		$replyTo:=$7
	End if 
End if 

If ($params>=8)
	If (Length:C16($8)>0)
		$header:=$8
	End if 
Else 
	
	$body:=$body+Email_Signature  // Modified by: mlb (5/8/13) make sure sig is at the end
End if 

If ($params>=9)
	If (Length:C16($9)>0)
		$cc:=$9
	End if 
End if 


$success:=True:C214
$err:=0

//#########
//$subject:="TESTING "+$subject
//#########

Case of 
	: (SMTP_New($SMTP_ID)#0)
		$success:=False:C215
	: (SMTP_Host($SMTP_ID; <>EMAIL_STMP_HOST)#0)
		$success:=False:C215
	: (SMTP_From($SMTP_ID; $from)#0)
		$success:=False:C215
	: (SMTP_ReplyTo($SMTP_ID; $replyTo)#0)
		$success:=False:C215
	: (SMTP_Subject($SMTP_ID; $subject)#0)
		$success:=False:C215
	: (SMTP_To($SMTP_ID; $distribList)#0)
		$success:=False:C215
	: (SMTP_Cc($SMTP_ID; $cc)#0)
		$success:=False:C215
	: (SMTP_Body($SMTP_ID; $body)#0)
		$success:=False:C215
		//: (SMTP_attachment ($SMTP_ID;$attachmentPath)#0)
		//$success:=False
		
	Else 
		//$authUserID:="mel.bohince"// Modified by: Mel Bohince (7/29/15) 
		//$authPWD:=Request("SMTP Pwd?";"";"Connect";"Cancel")
		//$err:=SMTP_Auth ($SMTP_ID;$authUserID;$authPWD)
		//If ($err#0)
		//$success:=False
		//End if 
		
		// Modified by: Mel Bohince (3/9/20) add auth back in for Office365
		//$err:=SMTP_Auth ($SMTP_ID;"administrator@arkay.com";"MacJob63977!")
		//$err:=SMTP_Auth ($SMTP_ID;"virtual.factory@arkay.com";"Arkay2015!")
		$err:=SMTP_Auth($SMTP_ID; $from; $pwd)
		If ($err#0)
			$success:=False:C215
		End if 
		
		If (Length:C16($header)>0)
			$err:=SMTP_AddHeader($SMTP_ID; "Content-Type:"; $header; 1)
			If ($err#0)
				$success:=False:C215
			End if 
		End if 
		
		If (Length:C16($attachmentPath)>0) & ($success)
			$err:=SMTP_Attachment($SMTP_ID; $attachmentPath; 2)  //4 kinda works
			If ($err#0)
				$success:=False:C215
			End if 
		End if 
		
		//adding a message id help with spam score
		$date:=fYYMMDD(4D_Current_date; 4; "")
		$time:=Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")
		$rand:=String:C10(((Random:C100%21)+10))
		$id:=$date+$time+$rand+"virtual.factory@arkay.com"
		$err:=SMTP_MessageID($SMTP_ID; $id; 1)  // may help with spam score
		If ($err#0)
			$success:=False:C215
		End if 
		
		If ($err=0) & ($success)
			$err:=IT_SetTimeOut(60)
			zwStatusMsg("EMAIL "+String:C10($err); "Send "+$subject+" to: "+$distribList)
			If (Current user:C182#"Designer")  // Modified by: Mel Bohince (1/21/16) 
				$err:=SMTP_Send($SMTP_ID)
			Else   //give option if designer
				If (Application type:C494=4D Server:K5:6)
					$err:=SMTP_Send($SMTP_ID)
				Else 
					If (Position:C15("[UsSp]"; $subject)>0)  //Subject has [UsSp]
						$err:=SMTP_Send($SMTP_ID)
					Else   //Subject does not have [UsSp]
						CONFIRM:C162("Send email "+$subject+" ?"; "Send"; "Don't")
						If (ok=1)
							$err:=SMTP_Send($SMTP_ID)
						End if 
					End if   //Done subject has [UsSp]
				End if 
			End if 
			If ($err#0)
				$success:=False:C215
			End if 
		End if 
		
		CREATE RECORD:C68([x_email_logs:101])
		// Modified by: Mel Bohince (7/15/21) server option for current date/time
		If (Application type:C494=4D Server:K5:6)  //if bckup gets cancelled, On Server Start hasn't init'd <>4d_Time object
			[x_email_logs:101]ReceivedDate:1:=Current date:C33
			[x_email_logs:101]ReceivedTime:2:=Current time:C178
		Else 
			[x_email_logs:101]ReceivedDate:1:=4D_Current_date
			[x_email_logs:101]ReceivedTime:2:=4d_Current_time
		End if 
		[x_email_logs:101]EmailFrom:3:=$from
		[x_email_logs:101]EmailTo:7:=$distribList
		[x_email_logs:101]EmailSubject:4:=$subject
		[x_email_logs:101]EmailBody:5:=$body
		[x_email_logs:101]CountAttachments:6:=Num:C11((Length:C16($attachmentPath)>0))
		If ($err=0)
			[x_email_logs:101]ErrorCode:9:="SENT"
		Else 
			[x_email_logs:101]ErrorCode:9:="ERROR: "+String:C10($err)
		End if 
		
		SAVE RECORD:C53([x_email_logs:101])
		UNLOAD RECORD:C212([x_email_logs:101])
End case 

If (Not:C34($success))
	zwStatusMsg("EMAIL"; "ERROR: sending message "+$subject+". "+String:C10($err)+" = "+IT_ErrorText($err))
	$0:="Email not sent, an error occured. Please try again."  // Added by: Mark Zinke (4/22/13)
Else 
	zwStatusMsg("EMAIL"; "SENT "+$subject+" to: "+$distribList)
	$0:=""  // Added by: Mark Zinke (4/22/13)
End if 

If ($SMTP_ID#0)
	$err:=SMTP_Clear($SMTP_ID)
End if 