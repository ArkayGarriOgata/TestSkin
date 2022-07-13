//%attributes = {"publishedWeb":true}
// Method: util_UserGetPIN () -> 
// ----------------------------------------------------
// by: mel: 11/02/04, 16:01:30
// ----------------------------------------------------
// Description:
// get user's pin from dialog with Password Font

C_TEXT:C284(sPIN; $0)
C_LONGINT:C283($tenMinutesAgo)
$tenMinutesAgo:=Current time:C178-(60*10)
If (<>lastPINentry<$tenMinutesAgo)
	$winRef:=Open form window:C675([zz_control:1]; "Authorize"; 5)
	BEEP:C151
	sPIN:=""
	zwStatusMsg("AUTHORIZE"; "Type in your Personal Identification Number and press <Return>")
	DIALOG:C40([zz_control:1]; "Authorize")
	CLOSE WINDOW:C154($winRef)
	<>lastPINentry:=Current time:C178-1
	<>PIN:=sPIN
	
Else 
	sPIN:=<>PIN
	ok:=1
End if 

If (ok=1)
	$0:=sPIN
Else 
	$0:="ABORTED"
	<>lastPINentry:=0
End if 