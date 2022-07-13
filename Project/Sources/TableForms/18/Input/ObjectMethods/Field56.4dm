If (([Process_Specs:18]iCoat3Type:23="Inline") & ([Process_Specs:18]iCoat3Matl:24="PS Dull"))
	BEEP:C151
	ALERT:C41("Can't use PS Dull inline.")
	[Process_Specs:18]iCoat3Matl:24:=""
End if 