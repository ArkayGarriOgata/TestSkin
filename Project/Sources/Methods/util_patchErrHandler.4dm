//%attributes = {"publishedWeb":true}
//PM: util_patchErrHandler() -> 
//@author mlb - 4/19/01  13:20
$text:="Error number: "+String:C10(error)+" at "+String:C10(iRow)
$text:=$text+Char:C90(13)+Char:C90(13)+emailBody

EMAIL_Sender("Patch Error"; ""; $text; "mel.bohince@arkay.com")
zwStatusMsg("Patch Error"; "Error number: "+String:C10(error)+" at "+String:C10(iRow))
<>fContinue:=False:C215
//ABORT