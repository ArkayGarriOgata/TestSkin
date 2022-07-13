If (Form event code:C388=On Load:K2:1)
	If (t18="No Cost")
		OBJECT SET FONT STYLE:C166(t18; 1)
	Else 
		OBJECT SET FONT STYLE:C166(t18; 0)
	End if 
End if 