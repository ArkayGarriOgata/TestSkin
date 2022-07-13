If (([Process_Specs:18]Coat3Type:17="Inline") & ([Process_Specs:18]Coat3Matl:18="PS Dull"))
	BEEP:C151
	ALERT:C41("Can't use PS Dull inline.")
	[Process_Specs:18]Coat3Matl:18:=""
End if 