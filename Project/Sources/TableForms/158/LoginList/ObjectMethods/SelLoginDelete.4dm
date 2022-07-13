//delete login

If (esSelLogins.length>0)
	uConfirm("Delete the highlighted row(s)?"; "Delete"; "Cancel")
	If (ok=1)
		
		esLogins:=esLogins.minus(esSelLogins)
		esSelLogins.drop()
		esLogins:=esLogins
		
	End if 
	
Else 
	BEEP:C151
End if 