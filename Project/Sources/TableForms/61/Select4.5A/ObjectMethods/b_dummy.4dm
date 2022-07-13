If (Form event code:C388=On Clicked:K2:4)
	If (dFrom#!00-00-00!)
		Cal_getDate(->dFrom; Month of:C24(dFrom); Year of:C25(dFrom))
	Else 
		Cal_getDate(->dFrom)
	End if 
	
	$To:=UtilGetDate(dFrom; "ThisMonth"; ->dTo)  //!00/00/00!
End if 
