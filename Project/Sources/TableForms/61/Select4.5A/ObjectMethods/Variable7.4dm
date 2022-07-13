If (Form event code:C388=On Clicked:K2:4)
	If (dTo#!00-00-00!)
		Cal_getDate(->dTo; Month of:C24(dTo); Year of:C25(dTo))
	Else 
		Cal_getDate(->dTo)
	End if 
End if 
