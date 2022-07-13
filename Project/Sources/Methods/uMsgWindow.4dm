//%attributes = {"publishedWeb":true}
//(P) uMsgWindow: presents simple message window
C_TEXT:C284($1)
If (True:C214)
	zwStatusMsg("MESSAGE:"; $1)
Else 
	MsgFloatWindow($1)
End if 
//• 7/23/98 cs  made this routine call new standard
//C_TEXT($1)
//uCenterWindow (250;35;720;"")
//MESSAGE(◊sCR+" "+$1)
//  `EOP