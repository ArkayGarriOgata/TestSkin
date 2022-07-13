//%attributes = {}

// Method: Email_html_body (title;preheader;body;maxwidth;distribution{;attch;reply;from})  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/31/15, 11:19:06
// ----------------------------------------------------
// Description
// send an html email with arbitrary body
//
// ----------------------------------------------------

C_TEXT:C284($r; $1; $2; $3; $5; $title; $preheader; $bodyData; $distribList; $attachmentPath; $emailHeader; $html; $r; $maxWidth)
C_TEXT:C284($6; $7; $8; $replyTo; $from; $attachmentPath)  //tramp arguments, offset from the orig param list
C_LONGINT:C283($4; $params)

$r:=Char:C90(13)
$title:=$1
$preheader:=$2
$bodyData:=$3
$maxWidth:=String:C10($4)
$params:=Count parameters:C259

If ($params>=5)
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

//here be the magic
$emailHeader:=" text/html; charset=us-ascii"+$r+$r

$html:="<!DOCTYPE html>"
$html:=$html+"<html>"
$html:=$html+"<head>"
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

//$html:=$html+"<img style=\"max-width:67%;display:block;margin:0 auto\" src=\"https://s3.amazonaws.com/twigsnapper.1/arkay/arkay-logo-350.jpg\" alt=\"Arkay Packaging\" />"
$html:=$html+"<img style=\"max-width:67%;display:block;margin:0 auto\" src=\"http://www.arkay.com/logo-vf.png\" alt=\"Arkay Packaging\" />"

$html:=$html+"<p style=\"font-size:16px;text-align:center;color:#666;font-weight:300;margin:20px\">"+$title+"</p>"

//$html:=$html+"<p style=\"font-size:16px;text-align:center;color:RED;font-weight:300\">THIS IS ONLY A TEST</p>"

//DATA BODY
$html:=$html+"<p style=\"font-size:16px;text-align:left;color:#666;font-weight:300;margin:20px\">"+$preheader+"</p>"

$html:=$html+"<p style=\"font-size:16px;text-align:left;color:#666;font-weight:500;margin:20px\">"+$bodyData+"</p>"


//FOOTER
$html:=$html+"<p style=\"margin:20px;font-size:9px;text-align:center;color:#8DB6CD\">DATE:"+String:C10(Current time:C178; HH MM AM PM:K7:5)+"-"+String:C10(Current date:C33; System date short:K1:1)+"</p>"
$html:=$html+"<p style=\"margin:20px;font-size:9px;text-align:center;color:#8DB6CD\">--delete this email immediately if your not the intended recipient or you'll be sorry--</p>"
$html:=$html+"<p style=\"font-size:9px;text-align:center;color:#8DB6CD\">aMs | Unsubscribe</p>"  //<a style=\"text-decoration:none\" href=\"#\">
$html:=$html+"</div>"  //email container
$html:=$html+"</div>"  //email-background
$html:=$html+"</body>"
$html:=$html+"</html>"


If (Current user:C182="Designer")
	$docName:=Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+".html"
	$docRef:=util_putFileName(->$docName)
	If ($docRef#?00:00:00?)
		SEND PACKET:C103($docRef; $html)
		CLOSE DOCUMENT:C267($docRef)
	End if 
End if 

EMAIL_Sender($title; ""; $html; $distribList; $attachmentPath; $replyTo; $from; $emailHeader)
