//%attributes = {"publishedWeb":true}
//PM: util_UserGroupMembershipImport() -> 
//@author Mel - 5/28/03  11:55

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
	
	RECEIVE PACKET:C104($docRef; $username; $cr)
	While (ok=1)
		util_TextParser(20; $username)
		$group:=Find in array:C230($aGroupNames; aParseArray{1})
		If ($group>-1)
			ARRAY LONGINT:C221($newGroups; 0)
			GET GROUP PROPERTIES:C613($aGroupNumbers{$group}; $name; $owner; $newGroups)
			
			For ($i; 2; Size of array:C274(aParseArray))
				$member:=Find in array:C230($aGroupNames; aParseArray{$i})
				If ($member>-1)
					INSERT IN ARRAY:C227($newGroups; 1; 1)
					$newGroups{1}:=$aGroupNumbers{$member}
				End if 
			End for 
			
			$gid:=Set group properties:C614($aGroupNumbers{$group}; $name; $owner; $newGroups)
		End if 
		
		util_TextParser
		zwStatusMsg("ADD GROUP"; $username)
		RECEIVE PACKET:C104($docRef; $username; $cr)
	End while 
	
	util_TextParser
	CLOSE DOCUMENT:C267($docRef)
End if   //ok