//%attributes = {"publishedWeb":true}
//PM: util_UserMembershipImport() -> 
//@author Mel - 5/22/03  16:15

C_TEXT:C284($t; $cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)

If (Count parameters:C259=0)
	CONFIRM:C162("Import Memberships?")
	If (ok=1)
		$docRef:=Open document:C264("")
	End if 
Else 
	$docRef:=Open document:C264($1)
End if 

If (ok=1)
	GET GROUP LIST:C610($aGroupNames; $aGroupNumbers)
	GET USER LIST:C609($aUserNames; $aUserNumbers)
	
	RECEIVE PACKET:C104($docRef; $username; $cr)
	While (ok=1)
		util_TextParser(20; $username)
		$user:=Find in array:C230($aUserNames; aParseArray{1})
		If ($user>-1)
			ARRAY LONGINT:C221($newGroups; 0)
			GET USER PROPERTIES:C611($aUserNumbers{$user}; $name; $startUp; $pwd; $nbLogin; $lastLogin; $newGroups)
			For ($i; 3; Size of array:C274(aParseArray))
				$group:=Find in array:C230($aGroupNames; aParseArray{$i})
				If ($group>-1)
					INSERT IN ARRAY:C227($newGroups; 1; 1)
					$newGroups{1}:=$aGroupNumbers{$group}
				End if 
			End for 
			
			$gid:=Set user properties:C612($aUserNumbers{$user}; $name; $startUp; *; $nbLogin; $lastLogin; $newGroups)
		End if 
		
		util_TextParser
		zwStatusMsg("ADD GROUP"; $username)
		RECEIVE PACKET:C104($docRef; $username; $cr)
	End while 
	
	util_TextParser
	CLOSE DOCUMENT:C267($docRef)
End if 

BEEP:C151
//