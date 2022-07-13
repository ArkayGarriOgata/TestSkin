If (User in group:C338(Current user:C182; "RoleLineManager"))
	CUT NAMED SELECTION:C334([Job_Forms_Machine_Tickets:61]; "hold")
	USE SET:C118("$ListboxSet0")
	APPLY TO SELECTION:C70([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Comment:25:="√ "+[Job_Forms_Machine_Tickets:61]Comment:25)
	USE NAMED SELECTION:C332("hold")
	
Else 
	uConfirm("Must be a  line manager to approve an entry."; "Ok"; "Just Checking")
End if 