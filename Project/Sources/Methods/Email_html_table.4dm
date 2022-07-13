//%attributes = {}

// Method: Email_html_table ($subject;$prehead;$tableData;max-width;$distribList )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/24/15, 14:05:42
// ----------------------------------------------------
// Description
// send an email with table based data
//
// ----------------------------------------------------
// Modified by: Mel Bohince (4/26/16) add cc to email
// Modified by: Mel Bohince (8/30/21) remove defunc aws s3 image src

C_TEXT:C284($1; $2; $3; $5; $title; $preheader; $tableData; $distribList; $attachmentPath; $emailHeader; $html; $r; $maxWidth; $9; $cc)
C_LONGINT:C283($4; $params)
$params:=Count parameters:C259
$title:=$1
$preheader:=$2
$tableData:=$3
$maxWidth:=String:C10($4)
$maxTable:=String:C10($4-10)

$r:=Char:C90(13)

If ($params>4)
	$distribList:=$5
Else 
	$distribList:="mel.bohince@arkay.com"
End if 

If ($params>=6)
	$attachmentPath:=$6
Else 
	$attachmentPath:=""
End if 

If ($params>=7)
	$replyTo:=$7
Else 
	$replyTo:=""
End if 

If ($params>=8)
	$from:=$8
Else 
	$from:=""
End if 

If ($params>=9)  // Modified by: Mel Bohince (4/26/16) add cc to email
	$cc:=$9
Else 
	$cc:=""
End if 

$emailHeader:=" text/html; charset=us-ascii"+$r+$r

$html:="<!DOCTYPE html>"
$html:=$html+"<html>"
$html:=$html+"<head>"
//$html:=$html+"<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">"
$html:=$html+"<title>"+$title+"</title>"
$html:=$html+"</head>"

$html:=$html+"<body>"

$html:=$html+"<div style=\"max-width:"+$maxWidth+"px;background:#8DB6CD;padding:2px\">"  //email-background

//PREHEADER for iphone and gmail readers
$html:=$html+"<div style=\"color:#8DB6CD;background:#8DB6CD;font-size:2px\">"  //preheader
$html:=$html+"<p style=\"color:#8DB6CD\">"+$preheader+"</p>"
$html:=$html+"</div>"  //end preheader
//max-width:"+$maxWidth+"px;
$html:=$html+"<div style=\"background:white;font-family:sans-serif;margin:0,auto;overflow:hidden;border-radius:5px\">"  //email container

// Modified by: Mel Bohince (8/30/21) amazon s3 account no longer available for emblem
//$html:=$html+"<img style=\"max-width:67%;display:block;margin:0 auto\" src=\"https://s3.amazonaws.com/twigsnapper.1/arkay/arkay-logo-350.jpg\" alt=\"Arkay Packaging\" />"
$html:=$html+"<img style=\"max-width:67%;display:block;margin:0 auto\" src=\"http://www.arkay.com/logo-vf.png\" alt=\"Arkay Packaging\" />"

$html:=$html+"<p style=\"font-size:16px;text-align:center;color:#666;font-weight:300\">"+$title+"</p>"

//$html:=$html+"<p style=\"font-size:16px;text-align:center;color:RED;font-weight:300\">THIS IS ONLY A TEST</p>"

//DATA TABLE
$html:=$html+"<table style=\"width:"+$maxTable+"px;margin:5px;border:1px solid #d6dde6;border-collapse: collapse\">"  //you need to style the tr and td before passing it in!
$html:=$html+$tableData
$html:=$html+"</table>"

//FOOTER
$html:=$html+"<p style=\"margin:20px;font-size:9px;text-align:center;color:#8DB6CD\">DATE:"+String:C10(Current time:C178; HH MM AM PM:K7:5)+"-"+String:C10(Current date:C33; System date short:K1:1)+" (GMT-05:00)</p>"
$html:=$html+"<p style=\"margin:20px;font-size:9px;text-align:center;color:#8DB6CD\">--delete this email immediately if your not the intended recipient or you'll be sorry--</p>"
$html:=$html+"<p style=\"font-size:9px;text-align:center;color:#8DB6CD\">aMs | Unsubscribe</p>"  //<a style=\"text-decoration:none\" href=\"#\">
$html:=$html+"</div>"  //email container
$html:=$html+"</div>"  //email-background
$html:=$html+"</body>"
$html:=$html+"</html>"

//utl_LogIt ("init")
//utl_LogIt ($html)
//utl_LogIt ("show")
If (Current user:C182="Designer")
	DELAY PROCESS:C323(Current process:C322; 120)
	$docName:=Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+".html"
	$docRef:=util_putFileName(->$docName)
	If ($docRef#?00:00:00?)
		SEND PACKET:C103($docRef; $html)
		CLOSE DOCUMENT:C267($docRef)
	End if 
End if 

EMAIL_Sender($title; ""; $html; $distribList; $attachmentPath; $replyTo; $from; $emailHeader; $cc)  // Modified by: Mel Bohince (4/26/16) add cc to email
