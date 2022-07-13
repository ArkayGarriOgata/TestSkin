If (([Process_Specs:18]Coat2Type:15="Inline") & ([Process_Specs:18]Coat2Matl:16="PS Dull"))
	BEEP:C151
	ALERT:C41("Can't use PS Dull inline.")
	[Process_Specs:18]Coat2Matl:16:=""
End if 