//%attributes = {"publishedWeb":true}
//PM: util_UserGroupImport()-> 
//@author Mel - 5/22/03  15:17

C_TEXT:C284($cr)
$cr:=Char:C90(13)
If (Count parameters:C259=0)
	CONFIRM:C162("Import Group names?")
	If (ok=1)
		$docRef:=Open document:C264("")
	End if 
Else 
	$docRef:=Open document:C264($1)
End if 

If (ok=1)
	RECEIVE PACKET:C104($docRef; $username; $cr)
	While (ok=1)
		$gid:=Set group properties:C614(-2; $username; 2)
		zwStatusMsg("ADD GROUP"; $username)
		RECEIVE PACKET:C104($docRef; $username; $cr)
	End while 
	
	CLOSE DOCUMENT:C267($docRef)
End if 

BEEP:C151
//