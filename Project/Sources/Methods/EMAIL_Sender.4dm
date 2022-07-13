//%attributes = {"publishedWeb":true}
// _______
// Method: EMAIL_Sender   ({ subject; bodyHdr; body; to; attachments[]; reply-to; fromNOTUSED; header; cc-to }) ->
// By: Mel Bohince @ 10/18/21, 11:39:51
// Description
// rewrite EMAIL_Sender fascade to use v18 SMTP Transporter
// maintaining the call signature of EMAIL_Sender
// ----------------------------------------------------
// Modified by: Garri Ogata (12/7/21) Changed CC to replace tabs with commas also added remove commas from front and back for To and CC

C_TEXT:C284($bodyHdr; $1; $2; $3; $4; $5; $6; $7; $8)

C_LONGINT:C283($params; $len)
C_TEXT:C284($t; $r; $comma; $maxWidth)

ARRAY TEXT:C222($atStripComma; 0)

$t:="\t"
$r:="\r"
$comma:=","
$maxWidth:="800"

APPEND TO ARRAY:C911($atStripComma; CorektComma)

C_OBJECT:C1216($smtpParams_o; $mail_o; $transporter_o; $status_o; $emailLog_e)

If (True:C214)  //set up the smtp host
	$smtpParams_o:=New object:C1471
	$smtpParams_o.host:=<>EMAIL_STMP_HOST  //"smtp.office365.com"
	$smtpParams_o.port:=25
	$smtpParams_o.user:=<>EMAIL_FROM  //"virtual.factory@arkay.com"
	$smtpParams_o.password:=<>EMAIL_POP3_PASSWORD  //Arkay2015!
	$smtpParams_o.acceptUnsecureConnection:=False:C215
End if 

If (True:C214)  //set up the default mail
	$mail_o:=New object:C1471
	$mail_o.from:=$smtpParams_o.user  //$mail_o.from  //override so that SMTP_Auth works watch out!!!!, must be From the smtp user,
	$mail_o.reply:="no-reply@arkay.com"  //reply seems to be ignored
	$mail_o.to:="mel.bohince@arkay.com"  //,bohince@gmail.com"
	$mail_o.cc:=""
	$mail_o.subject:="*no subject*"
	$mail_o.textBodyHdr:=""
	$bodyText:="no body"  //$mail_o.htmlBody:=$mail_o.htmlBody+Replace string($3;"\r";"<br>")
	$mail_o.attachments:=New collection:C1472
	
	$mail_o.header:=""
End if 

//*Overrides that come in as parameters:
$params:=Count parameters:C259

If ($params>=1)
	If (Length:C16($1)>0)
		$mail_o.subject:=$1
	End if 
End if 

If ($params>=2)
	If (Length:C16($2)>0)
		$mail_o.textBodyHdr:=$2+$r+$r
	End if 
End if 

If ($params>=3)
	If (Length:C16($3)>0)
		$bodyText:=$3
	End if 
End if 

//prep the text body
If (Position:C15("<!DOCTYPE html>"; $bodyText)=0)  //plain text passed in
	
	$mail_o.textBody:=$mail_o.textBodyHdr+$bodyText+Email_Signature
	
	//prep the html body
	$html:="<!DOCTYPE html>"
	$html:=$html+"<html>"
	$html:=$html+"<head>"
	$html:=$html+"<title>"+$mail_o.subject+"</title>"
	$html:=$html+"</head>"
	
	$html:=$html+"<body>"
	
	$html:=$html+"<div style=\"max-width:"+$maxWidth+"px;background:#8DB6CD;padding:2px\">"  //email-background
	
	//PREHEADER for iphone and gmail readers
	$html:=$html+"<div style=\"color:#8DB6CD;background:#8DB6CD;font-size:9px\">"  //preheader
	$html:=$html+"<p style=\"color:#fff;text-align:center\">"+Replace string:C233($mail_o.textBodyHdr; "\r"; "<br>")+"</p>"
	$html:=$html+"</div>"  //end preheader
	//max-width:"+$maxWidth+"px;
	
	
	$html:=$html+"<div style=\"background:white;font-family:sans-serif;margin:0,auto;overflow:hidden;border-radius:5px\">"  //email container
	
	$html:=$html+"<img style=\"max-width:67%;display:block;margin:0 auto\" src=\"http://www.arkay.com/logo-vf.png\" alt=\"Arkay Packaging\" />"
	
	$html:=$html+"<p style=\"font-size:16px;text-align:center;color:#666;font-weight:300;margin:20px\">"+$mail_o.subject+"</p>"
	
	//$html:=$html+"<p style=\"font-size:16px;text-align:center;color:RED;font-weight:300\">THIS IS ONLY A TEST</p>"
	
	//DATA BODY
	$html:=$html+"<p style=\"font-size:16px;text-align:left;color:#666;font-weight:500;margin:20px\">"+Replace string:C233($bodyText; "\r"; "<br>")+"</p>"
	
	
	//FOOTER
	$html:=$html+"<p style=\"margin:20px;font-size:9px;text-align:center;color:#8DB6CD\">DATE:"+String:C10(Current time:C178; HH MM AM PM:K7:5)+"-"+String:C10(Current date:C33; System date short:K1:1)+"</p>"
	$html:=$html+"<p style=\"margin:20px;font-size:9px;text-align:center;color:#8DB6CD\">--delete this email immediately if your not the intended recipient or you'll be sorry--</p>"
	$html:=$html+"<p style=\"font-size:9px;text-align:center;color:#8DB6CD\">aMs | Unsubscribe</p>"  //<a style=\"text-decoration:none\" href=\"#\">
	$html:=$html+Email_Signature("html")
	$html:=$html+"</div>"  //email container
	$html:=$html+"</div>"  //email-background
	$html:=$html+"</body>"
	$html:=$html+"</html>"
	
	$mail_o.htmlBody:=$html
	
Else 
	$mail_o.textBody:=$mail_o.textBodyHdr+"HTML Mail Sent"+Email_Signature
	$mail_o.htmlBody:=$bodyText
End if 

//parse out the distribution list, want them delimited with commas
If ($params>=4)
	If (Length:C16($4)>1)
		$mail_o.to:=$4
	End if 
End if 

$mail_o.to:=Replace string:C233($mail_o.to; $t; $comma)  //replace <tab> with commas
$mail_o.to:=Replace string:C233($mail_o.to; ",,"; $comma)  //this happened once in 2005 ;-)
$mail_o.to:=Core_Text_RemoveT($mail_o.to; ->$atStripComma; 3)  //Strip commas from front and back

//$len:=Length($mail_o.to)
//If ($mail_o.to[[$len]]=$comma)  //make it end without delimitor
//$mail_o.to:=Substring($mail_o.to;1;$len-1)
//End if 

If ($params>=5)
	If (Length:C16($5)>1)
		$mail_o.attachments.push(MAIL New attachment:C1644($5))
	End if 
End if 

If ($params>=6)
	If (Length:C16($6)>0)
		$mail_o.reply:=$6
	End if 
End if 

If ($params>=7)
	If (Length:C16($7)>0)  //from specified
		$mail_o.reply:=$7  //pre-microsoftExchange, use to be able to change the from, now just change the reply-to
	End if 
End if 

If ($params>=8)
	If (Length:C16($8)>0)
		$mail_o.header:=$8
	End if 
End if 

If ($params>=9)
	If (Length:C16($9)>0)
		$mail_o.cc:=$9
	End if 
End if 

$mail_o.cc:=Replace string:C233($mail_o.cc; $t; $comma)  //replace <tab> with commas
$mail_o.cc:=Replace string:C233($mail_o.cc; ",,"; $comma)  //this happened once in 2005 ;-)
$mail_o.cc:=Core_Text_RemoveT($mail_o.cc; ->$atStripComma; 3)  //Strip commas from front and back

// send it
ON ERR CALL:C155("e_EmptyErrorMethod")

$transporter_o:=SMTP New transporter:C1608($smtpParams_o)
$status_o:=$transporter_o.send($mail_o)

ON ERR CALL:C155("")

// Verification if send mail is a success or not and display a message
$emailLog_e:=ds:C1482.x_email_logs.new()
$emailLog_e.ReceivedDate:=Current date:C33
$emailLog_e.ReceivedTime:=Current time:C178
$emailLog_e.EmailFrom:=$mail_o.from
$emailLog_e.EmailTo:=$mail_o.to
$emailLog_e.EmailSubject:=$mail_o.subject
$emailLog_e.EmailBody:=$mail_o.textBody
$emailLog_e.CountAttachments:=$mail_o.attachments.length

If ($status_o.success)
	$emailLog_e.ErrorCode:="SENT"
	zwStatusMsg("EMAIL"; "SENT "+$mail_o.subject+" to: "+$mail_o.to)
	
Else 
	$emailLog_e.ErrorCode:=$status_o.statusText
	zwStatusMsg("EMAIL"; "ERROR: sending message "+$mail_o.subject+". "+String:C10($err)+" = "+$status_o.statusText)
End if 

//If ($status_o.status=0)
//ARRAY LONGINT($tcodes;0)
//ARRAY LONGINT($tcmps;0)
//ARRAY TEXT($tmess;0)
//GET LAST ERROR STACK($tcodes;$tcmps;$tmess)
//  //ALERT("An error occurred: "+$tmess{1})
//Else 
//  //ALERT("An error occurred: "+$status_o.statusText)
//End if

$emailLog_e.save()  //save the entity
