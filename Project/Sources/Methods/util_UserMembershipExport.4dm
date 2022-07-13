//%attributes = {"publishedWeb":true}
//PM: util_UserMembershipExport({roles;roanoke;func}) -> 
//@author Mel - 5/22/03  16:00

C_TEXT:C284($t; $cr)
$t:=Char:C90(9)
$cr:=Char:C90(13)
$text:=""
$fileName:=""
$continue:=False:C215
$rollsOnly:=False:C215
$roan:=False:C215
If (Count parameters:C259=0)
	path:=""
	CONFIRM:C162("Export user memberships?")
	If (ok=1)
		$continue:=True:C214
		CONFIRM:C162("Which type of membership?"; "Role"; "Function")
		If (ok=1)
			$rollsOnly:=True:C214
			$fileName:="RolesOnly.txt"
		Else 
			$rollsOnly:=False:C215
			CONFIRM:C162("Roanoke users only?"; "Roanoke"; "Just Function")
			If (ok=1)
				$roan:=True:C214
				$fileName:="RoanokeUsers.txt"
			Else 
				$roan:=False:C215
				$fileName:="FunctionsOnly.txt"
			End if 
		End if 
	End if 
	
Else 
	$continue:=True:C214
	$rollsOnly:=$1
	If ($rollsOnly)
		$fileName:=path+"RolesOnly.txt"
	Else 
		$roan:=$2
		If ($roan)
			$fileName:=path+"RoanokeUsers.txt"
		Else 
			$fileName:=path+"FunctionsOnly.txt"
		End if 
	End if 
End if   //count params

If ($continue)
	GET GROUP LIST:C610($aGroupNames; $aGroupNumbers)
	GET USER LIST:C609($aUserNames; $aUserNumbers)
	SORT ARRAY:C229($aUserNames; $aUserNumbers; >)
	For ($user; 1; Size of array:C274($aUserNames))
		If ($aUserNames{$user}#"x@")
			ARRAY LONGINT:C221($aMemberships; 0)
			GET USER PROPERTIES:C611($aUserNumbers{$user}; $name; $startUp; $pwd; $nbLogin; $lastLogin; $aMemberships)
			$text:=$text+$aUserNames{$user}+$t+$startUp
			For ($group; 1; Size of array:C274($aMemberships))
				$hit:=Find in array:C230($aGroupNumbers; $aMemberships{$group})
				If ($hit>-1)
					If ($rollsOnly)
						If (Substring:C12($aGroupNames{$hit}; 1; 4)="Role")
							$text:=$text+$t+$aGroupNames{$hit}
						End if 
						
					Else 
						If (Substring:C12($aGroupNames{$hit}; 1; 4)#"Role")
							
							If ($roan)
								If (Substring:C12($aGroupNames{$hit}; 1; 4)="Roan")
									$text:=$text+$t+$aGroupNames{$hit}
								End if 
								
							Else 
								If (Substring:C12($aGroupNames{$hit}; 1; 4)#"Roan")
									$text:=$text+$t+$aGroupNames{$hit}
								End if 
							End if 
						End if 
						
					End if 
				End if 
			End for 
			$text:=$text+$cr
		End if 
	End for 
	$docRef:=Create document:C266($fileName; "TEXT")
	SEND PACKET:C103($docRef; $text)
	CLOSE DOCUMENT:C267($docRef)
End if 

$text:=""
BEEP:C151
//