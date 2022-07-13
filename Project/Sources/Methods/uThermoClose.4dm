//%attributes = {"publishedWeb":true}
//Procedure: uThermoClose()  041996  MLB
//avoid ThermoSet uthermoupdate

If (Not:C34(Application type:C494=4D Server:K5:6))
	If (useStatusBar)
		zwStatusTherm("close")
		CLEAR SEMAPHORE:C144("$isStatusThermo")
	Else 
		ThermoMax:=0
		CLOSE WINDOW:C154
	End if 
End if 