CONFIRM:C162("You should be duplicating from the Art tab of the Project Control Center"+" by clicking the 'Make Like Product Code...'."; "Cancel"; "Continue")
If (ok=0)
	CONFIRM:C162("Do you really want to do this the hard way?"; "Cancel"; "Continue")
	If (ok=0)
		FgDuplicate("*")
	End if 
End if 