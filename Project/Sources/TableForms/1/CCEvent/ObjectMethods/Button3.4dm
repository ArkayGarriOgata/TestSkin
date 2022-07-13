
If (User in group:C338(Current user:C182; "WorkInProcess"))
	ViewSetter(2; ->[Job_Forms_Items:44])
Else 
	uConfirm("Access denied. Must be in WorkInProcess group.")
End if 
//