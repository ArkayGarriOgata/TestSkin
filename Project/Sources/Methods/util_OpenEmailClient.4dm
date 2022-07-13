//%attributes = {"publishedWeb":true}
//PM:  util_OpenEmailCliento;cc;bcc;subject;body)  3/30/01  mlb
//open default email client
C_TEXT:C284($url)
$to:="mailto:"
$cc:=""
$bcc:=""  //"&bcc="+"email.records@arkay.com"
$subject:=""
$body:=""

If (Length:C16($1)>0)
	$to:=$to+$1+"?"
Else 
	$to:=$to+"somebody@somewhere.com?"
End if 

If (Length:C16($2)>0)
	$cc:="cc="+$2
End if 

If (Length:C16($3)>0)
	$bcc:="&bcc="+$3
End if 

If (Length:C16($4)>0)
	$subject:="&subject="+$4
End if 

If (Length:C16($5)>0)
	$body:=Replace string:C233($5; "&"; "and")
	$body:="&body="+$body
End if 


$url:=$to+$cc+$bcc+$subject+$body
//$url:=Replace string($url;" ";"%20")  `%hex to encode special chars
//$url:=Replace string($url;"#";"%23")  `%hex to encode special chars
//$url:=Replace string($url;Char(34);"%22")  `make double quote a single quote
//$url:=Replace string($url;"&";"%26")  `THIS HAS A VERY BAD EFFECT
OPEN URL:C673($url)
//