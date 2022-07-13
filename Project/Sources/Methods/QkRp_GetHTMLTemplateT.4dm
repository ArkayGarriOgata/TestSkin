//%attributes = {}
//Method:  QkRp_GetHTMLTemplateT=>tHTMLTemplate
//Description:  This method returns the HTML Template to set properties for an HTML document with QuikReport
//. NOTE:  This uses HTML 4 which uses <font face this is obsolete in HTML 5 this could break at some point 
//   and would have to be changed to use css. This template was created by using QR Get HTML template as a start

If (True:C214)  //Intialization
	
	C_TEXT:C284($0; $tHTMLTemplate)
	
	$tHTMLTemplate:=CorektBlank
	
End if   //Done Initialize

$tHTMLTemplate:=$tHTMLTemplate+"<html>"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<head>"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<meta http-equiv="+CorektDoubleQuote+"Content-Type"+CorektDoubleQuote+" content="+CorektDoubleQuote+"text/html;charset=<!--#4DQRCharSet-->"+CorektDoubleQuote+">"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"</head>"
$tHTMLTemplate:=$tHTMLTemplate+"<body bgcolor="+CorektDoubleQuote+"#FFFFFF"+CorektDoubleQuote+" text="+CorektDoubleQuote+"#000000"+CorektDoubleQuote+">"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<table border=1>"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--#4DQRHeader-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<tr>"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--#4DQRCol-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<td bgcolor="+CorektDoubleQuote+"<!--#4DQRBgcolor-->"+CorektDoubleQuote+">"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--#4DQRFont-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--#4DQRFace-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<font face="+CorektDoubleQuote+"Helvetica"+CorektDoubleQuote+" size="+CorektDoubleQuote+"4"+CorektDoubleQuote+">"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--#4DQRData-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--/#4DQRFace-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--/#4DQRFont-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"</td>"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--/#4DQRCol-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"</tr>"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--/#4DQRHeader-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--#4DQRRow-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<tr>"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--#4DQRCol-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<td bgcolor="+CorektDoubleQuote+"<!--#4DQRBgcolor-->"+CorektDoubleQuote+">"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--#4DQRFont-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--#4DQRFace-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<font face="+CorektDoubleQuote+"Helvetica"+CorektDoubleQuote+"size="+CorektDoubleQuote+"3"+CorektDoubleQuote+">"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--#4DQRData-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--/#4DQRFace-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--/#4DQRFont-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"</td>"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--/#4DQRCol-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"</tr>"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"<!--/#4DQRRow-->"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"</table>"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"</body>"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"</html>"+CorektCR
$tHTMLTemplate:=$tHTMLTemplate+"</source>"+CorektCR

$0:=$tHTMLTemplate
