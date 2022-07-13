//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/16/06, 16:33:18
// ----------------------------------------------------
// Method: ug_LoadPasswords
// Description
// 
//
// Parameters
// ----------------------------------------------------
$docRef:=Open document:C264("")
If (ok=1)
	RECEIVE PACKET:C104($docRef; $user_password; Char:C90(13))
	While (ok=1)
		$t:=Position:C15(Char:C90(9); $user_password)
		$user:=Substring:C12($user_password; 1; ($t-1))
		$password:=Substring:C12($user_password; ($t+1))
		QUERY:C277([ug_Users:141]; [ug_Users:141]name:2=$user)
		If (Records in selection:C76([ug_Users:141])>0)
			[ug_Users:141]password:4:=$password
			SAVE RECORD:C53([ug_Users:141])
		End if 
		RECEIVE PACKET:C104($docRef; $user_password; Char:C90(13))
	End while 
	
End if 
CLOSE DOCUMENT:C267($docRef)
UNLOAD RECORD:C212([ug_Users:141])