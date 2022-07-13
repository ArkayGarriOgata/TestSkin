//%attributes = {"publishedWeb":true}
//PM: util_UserGroupMembershipExport() -> 
//@author Mel - 5/23/03  15:10

C_TEXT:C284($t; $cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)
$text:=""

If (Count parameters:C259=0)
	CONFIRM:C162("Export group within group memberships?")
	path:=""
Else 
	ok:=Num:C11($1)
End if 

If (ok=1)
	GET GROUP LIST:C610($aGroupNames; $aGroupNumbers)
	SORT ARRAY:C229($aGroupNames; $aGroupNumbers; >)
	
	For ($group; 1; Size of array:C274($aGroupNames))
		ARRAY LONGINT:C221($aMemberships; 0)
		GET GROUP PROPERTIES:C613($aGroupNumbers{$group}; $name; $owner; $aMemberships)
		$text:=$text+$aGroupNames{$group}
		For ($member; 1; Size of array:C274($aMemberships))
			$hit:=Find in array:C230($aGroupNumbers; $aMemberships{$member})
			If ($hit>-1)
				$text:=$text+$t+$aGroupNames{$hit}
			End if 
		End for 
		$text:=$text+$cr
		zwStatusMsg("EXPORT"; $aGroupNames{$group})
	End for 
	
	$docRef:=Create document:C266(path+"GroupInGroup.txt"; "TEXT")
	SEND PACKET:C103($docRef; $text)
	CLOSE DOCUMENT:C267($docRef)
End if 
$text:=""
BEEP:C151
//