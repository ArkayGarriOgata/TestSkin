//%attributes = {"publishedWeb":true}
//PM:  util_UserNameDelete  3/05/01  mlb
//delete usernames begining with x
CONFIRM:C162("Delete user names begining with x?")
If (ok=1)
	GET USER LIST:C609($aUserNames; $aUserNumbers)
	For ($i; 1; Size of array:C274($aUserNames))
		If (Not:C34(Is user deleted:C616($aUserNumbers{$i})))
			If ($aUserNames{$i}="x@")
				DELETE USER:C615($aUserNumbers{$i})
			End if 
		End if 
	End for 
End if 
//