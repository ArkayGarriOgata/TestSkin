//%attributes = {"publishedWeb":true}
//PM: util_UserNameImport() -> 
//@author Mel - 5/22/03  15:16

//PM: util_UserNameExport() -> 
//@author Mel - 5/22/03  15:16
C_TEXT:C284($cr)
$cr:=Char:C90(13)
If (Count parameters:C259=0)
	CONFIRM:C162("Import user names?")
	If (ok=1)
		$docRef:=Open document:C264("")
	End if 
Else 
	$docRef:=Open document:C264($1)
End if 

If (ok=1)
	READ WRITE:C146([Users:5])
	ALL RECORDS:C47([Users:5])
	APPLY TO SELECTION:C70([Users:5]; [Users:5]zCount:10:=0)
	
	RECEIVE PACKET:C104($docRef; $username; $cr)
	While (ok=1)
		QUERY:C277([Users:5]; [Users:5]UserName:11=$username)
		If (Records in selection:C76([Users:5])=1)
			[Users:5]zCount:10:=Set user properties:C612(-2; $username; "x"; ""; 0; !00-00-00!)
			SAVE RECORD:C53([Users:5])
			zwStatusMsg("ADD USER"; $username)
		End if 
		RECEIVE PACKET:C104($docRef; $username; $cr)
	End while 
	
	CLOSE DOCUMENT:C267($docRef)
End if 
BEEP:C151
//