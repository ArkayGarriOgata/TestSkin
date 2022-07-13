//%attributes = {"publishedWeb":true}
//PM: Email_Signature() -> text
//@author mlb - 4/18/01  09:33
//mlb move datetime stamp into this mehtod

C_TEXT:C284($0; $text; $1)
C_TEXT:C284($cr)



If (Count parameters:C259=0)  //orig
	
	$cr:=Char:C90(13)
	$text:=$cr+$cr+"DATE:"+String:C10(Current time:C178; HH MM AM PM:K7:5)+"-"+String:C10(Current date:C33; System date short:K1:1)
	$text:=$text+$cr+$cr+" @@@@@@@@@@@@@@@@@@@@@@@@ "+$cr
	$text:=$text+"@       rrrrrk      k    @"+$cr
	$text:=$text+"@     rrrrrrrk     k     @"+$cr
	$text:=$text+"@    rr     rk     k     @"+$cr
	$text:=$text+"@    rr     rk     k     @"+$cr
	$text:=$text+"@    rrr    rk   kkk     @"+$cr
	$text:=$text+"@      rrrrrrkkkkkk      @"+$cr
	$text:=$text+"@     rr    rk    kkk    @"+$cr
	$text:=$text+"@    r      rk      rk   @"+$cr
	$text:=$text+"@    r      rk      kk   @"+$cr
	$text:=$text+"@    r      rk      k    @"+$cr
	$text:=$text+"@   rr      rk      kk   @"+$cr
	//$text:=$text+"@                        @"+$cr
	$text:=$text+" @@@@@@@@@@@@@@@@@@@@@@@@ "+$cr
	$text:=$text+"    MANAGEMENT  SYSTEM "+$cr+$cr
	$text:=$text+"--delete this email immediately if your not the intended recipient or you'll be s"+"orry--"+$cr
	
Else   //send back an html div
	
	$cr:="<br>"
	$sp:="&nbsp;"
	
	$text:="<div style=\"font-family:monospace;font-size:9px;text-align:center;color:#8DB6CD;font-weight:100;margin:20px\">"
	
	$text:=$text+$cr+$cr
	$text:=$text+$sp+"@@@@@@@@@@@@@@@@@@@@@@@@ "+$cr
	$text:=$text+"@"+(7*$sp)+"rrrrrk"+(7*$sp)+"k"+(3*$sp)+"@"+$cr
	$text:=$text+"@"+(5*$sp)+"rrrrrrrk"+(5*$sp)+"k"+(5*$sp)+"@"+$cr
	$text:=$text+"@"+(4*$sp)+"rr"+(5*$sp)+"rk"+(5*$sp)+"k"+(5*$sp)+"@"+$cr
	$text:=$text+"@"+(4*$sp)+"rr"+(5*$sp)+"rk"+(5*$sp)+"k"+(5*$sp)+"@"+$cr
	$text:=$text+"@"+(4*$sp)+"rrr"+(4*$sp)+"rk"+(3*$sp)+"kkk"+(5*$sp)+"@"+$cr
	$text:=$text+"@"+(6*$sp)+"rrrrrrkkkkkk"+(6*$sp)+"@"+$cr
	$text:=$text+"@"+(5*$sp)+"rr"+(4*$sp)+"rk"+(4*$sp)+"kkk"+(4*$sp)+"@"+$cr
	$text:=$text+"@"+(4*$sp)+"r"+(6*$sp)+"rk"+(6*$sp)+"rk"+(3*$sp)+"@"+$cr
	$text:=$text+"@"+(4*$sp)+"r"+(6*$sp)+"rk"+(6*$sp)+"kk"+(3*$sp)+"@"+$cr
	$text:=$text+"@"+(4*$sp)+"r"+(6*$sp)+"rk"+(6*$sp)+"k"+(4*$sp)+"@"+$cr
	$text:=$text+"@"+(3*$sp)+"rr"+(6*$sp)+"rk"+(6*$sp)+"kk"+(3*$sp)+"@"+$cr
	//$text:=$text+"@                        @"+$cr
	$text:=$text+$sp+"@@@@@@@@@@@@@@@@@@@@@@@@ "+$cr
	$text:=$text+(4*$sp)+"MANAGEMENT  SYSTEM "+$cr+$cr
	
	$text:=$text+"</div>"
	
End if 

$0:=$text