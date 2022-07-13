If ((Current user:C182="Administrator") | (User in group:C338(Current user:C182; "RolePayRoll")))
	ViewSetter(2; ->[Users:5])  //(S) [CONTROL]AdminEvent'ibMod
Else 
	BEEP:C151
	ALERT:C41("Log in as Administrator  or RolePayRoll to modify a user.")
End if 
//EOS