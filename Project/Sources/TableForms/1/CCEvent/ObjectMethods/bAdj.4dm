// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/06/13, 21:57:22
// ----------------------------------------------------
// Method: [zz_control].CCEvent.bAdj
// ----------------------------------------------------

If (User in group:C338(Current user:C182; "WorkInProcess"))
	ViewSetter(2; ->[Job_Forms_Items:44])
Else 
	uConfirm("Access denied. Must be in WorkInProcess group.")
End if 