If (([Process_Specs:18]iCoat2Type:21="Inline") & ([Process_Specs:18]iCoat2Matl:22="PS Dull"))
	BEEP:C151
	ALERT:C41("Can't use PS Dull inline.")
	[Process_Specs:18]iCoat2Matl:22:=""
End if 