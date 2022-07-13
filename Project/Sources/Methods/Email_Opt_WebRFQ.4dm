//%attributes = {"publishedWeb":true}
//PM: Email_Opt_WebRFQ() -> 
//@author mlb - 4/17/01  13:36

C_TEXT:C284($pathForScratchFiles; $text)
C_TIME:C306($docRef)

$pathForScratchFiles:=Temporary folder:C486

//utl_LogIt ("init")
//utl_LogIt (emailBody;0)
//utl_LogIt ("show")

For ($i; 1; Size of array:C274(aEmailAttachment))
	$docRef:=Open document:C264($pathForScratchFiles+aEmailAttachment{$i})
	If (OK=1)
		RECEIVE PACKET:C104($docRef; $text; 32000)
		emailBody:=emailBody+Char:C90(13)+$text
		CLOSE DOCUMENT:C267($docRef)
		//utl_LogIt ("init")
		//utl_LogIt ($text;0)
		//utl_LogIt ("show")
	End if 
End for 

$netscape:=Position:C15("&phone"; emailBody)
If ($netscape=0)
	$text:=Replace string:C233(emailBody; Char:C90(13)+Char:C90(13); "&")
	$text:=Substring:C12($text; 2)
Else 
	$text:=Replace string:C233(emailBody; Char:C90(13)+Char:C90(13); "&")
End if 

$text:=Replace string:C233($text; "%40"; "@")
$text:=Replace string:C233($text; "+"; " ")

ARRAY TEXT:C222($aPair; 84)
ARRAY TEXT:C222($aValue; 84)
For ($i; 1; Size of array:C274($aPair))
	$end:=Position:C15("="; $text)
	$aPair{$i}:=Substring:C12($text; 1; ($end-1))
	$text:=Substring:C12($text; ($end+1))
	
	$end:=Position:C15("&"; $text)
	$aValue{$i}:=Substring:C12($text; 1; ($end-1))
	$text:=Substring:C12($text; ($end+1))
End for 

fileNum:=Table:C252(->[Estimates:17])
CREATE RECORD:C68([Estimates:17])
[Estimates:17]EstimateNo:1:=EstOffsetAdjust  //• 1/9/98 cs check that offset & prefix are correctly set     
[Estimates:17]DateOriginated:19:=4D_Current_date
[Estimates:17]CreatedBy:59:="WEB"
[Estimates:17]Status:30:="New"
[Estimates:17]Last_Differential_Number:31:=0  //this is a number used to calculate AA, AB...ZZ using INT() & MOD functions
[Estimates:17]NumberOfForms:32:=1
[Estimates:17]ModDate:37:=4D_Current_date
[Estimates:17]ModWho:38:=<>zResp
[Estimates:17]z_Num_ShipTos:4:=1
[Estimates:17]z_Num_Releases:12:=1
[Estimates:17]BreakOutSpls:10:=True:C214  //• 3/25/98 cs added at Ralph request
//[ESTIMATE]ProjectNumber:=Pjt_getReferId   `•5/03/00  mlb  
$i:=Find in array:C230($aPair; "cust")
[Estimates:17]CustomerName:47:=$aValue{$i}
For ($i; 1; Size of array:C274($aPair))
	[Estimates:17]Comments:34:=[Estimates:17]Comments:34+$aPair{$i}+" = "+$aValue{$i}+Char:C90(13)
End for 
SAVE RECORD:C53([Estimates:17])

emailResponse:="Estimate "+[Estimates:17]EstimateNo:1+" has been submitted. "
$i:=Find in array:C230($aPair; "email")
$0:=$aValue{$i}
REDUCE SELECTION:C351([Estimates:17]; 0)