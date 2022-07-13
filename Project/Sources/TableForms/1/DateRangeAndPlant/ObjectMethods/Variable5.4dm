If (Form event code:C388=On Clicked:K2:4)
	If (dDateEnd#!00-00-00!)
		Cal_getDate(->dDateEnd; Month of:C24(dDateEnd); Year of:C25(dDateEnd))
	Else 
		Cal_getDate(->dDateEnd)
	End if 
End if 
