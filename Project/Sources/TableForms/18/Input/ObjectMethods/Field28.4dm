If (([Process_Specs:18]Coat1Type:13="Inline") & ([Process_Specs:18]Coat1Matl:14="PS Dull"))
	BEEP:C151
	ALERT:C41("Can't use PS Dull inline.")
	[Process_Specs:18]Coat1Matl:14:=""
End if 