If (([Process_Specs:18]iCoat1Type:19="Inline") & ([Process_Specs:18]iCoat1Matl:20="PS Dull"))
	BEEP:C151
	ALERT:C41("Can't use PS Dull inline.")
	[Process_Specs:18]iCoat1Matl:20:=""
End if 