//%attributes = {}

// Method: Email_html_template ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/24/15, 12:47:17
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

$r:=Char:C90(13)

//mime headers

$emailHeader:=" text/html; charset=us-ascii"+$r+$r

$subject:="*no subject*"
$distribList:="mel.bohince@arkay.com"
$bodyHdr:=""
$body:="no body"
$attachmentPath:=""
$header:=""
$from:=<>EMAIL_FROM
$replyTo:=<>EMAIL_REPLYTO
//*Overrides:
$params:=Count parameters:C259
$SMTP_ID:=0


$html:="<!DOCTYPE html>"


$html:=$html+"<html>"

$html:=$html+"<head>"
$html:=$html+"<title>Example document</title>"
$html:=$html+"</head>"

$html:=$html+"<body>"

$html:=$html+"<table cellspacing=\"0\" cellpadding=\"0\" border=\"0\">"
$html:=$html+"<tr>"
$html:=$html+"<td>"

$html:=$html+"<table cellspacing=\"0\" cellpadding=\"0\" border=\"0\">"

$html:=$html+"<tr bgcolor=\"#8DB6CD\">"
$html:=$html+"<td width=\"50\">Item A</td>"
$html:=$html+"<td width=\"450\">2.4oz liquied gold</td>"
$html:=$html+"</tr>"

$html:=$html+"<tr style=\"background-color:#ccc;font-weight:300;color:red\">"
$html:=$html+"<td style=\"font-weight:300;color:#fff\" width=\"50\">Item B</td>"
$html:=$html+"<td style=\"font-weight:500;color:blue\" width=\"450\">6.8oz liquied gold</td>"
$html:=$html+"</tr>"
$html:=$html+"</table>"

$html:=$html+"</td>"
$html:=$html+"</tr>"
//
$html:=$html+"<tr>"
$html:=$html+"<td>"
$html:=$html+"."
$html:=$html+"</td>"
$html:=$html+"</tr>"

$html:=$html+"<tr>"
$html:=$html+"<td>"
$html:=$html+"DATE:"+String:C10(Current time:C178; HH MM AM PM:K7:5)+"-"+String:C10(Current date:C33; System date short:K1:1)
$html:=$html+"</td>"
$html:=$html+"</tr>"

$html:=$html+"<tr>"
$html:=$html+"<td>"
$html:=$html+"<img src=\"https://s3.amazonaws.com/twigsnapper.1/arkay/arkay-logo-350.jpg\" alt=\"Arkay Packaging\" />"
$html:=$html+"</td>"
$html:=$html+"</tr>"

$html:=$html+"</table>"

$html:=$html+"<hr />"

$html:=$html+"<ul><li>Coffee</li><li>Tea</li><li>Milk</li></ul>"

$html:=$html+"<dl style=\"border:1px solid #d6dde6;padding:20px\"><dt style=\"margin-top:20px\">Coffee</dt><dd style=\"margin-left:50px\">Black hot drink</dd><dt style=\"margin-top:20px\">Milk</dt><dd style=\"margin-left:50px\">White cold drink</dd></dl>"


$html:=$html+"</body>"
$html:=$html+"</html>"

EMAIL_Sender("test8"; ""; $html; $distribList; ""; ""; ""; $emailHeader)
