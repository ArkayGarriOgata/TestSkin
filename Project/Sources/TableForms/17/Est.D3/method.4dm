If (Form event code:C388=On Load:K2:1)
	If (t12="No Cost")
		OBJECT SET FONT STYLE:C166(t12; 1)
	Else 
		OBJECT SET FONT STYLE:C166(t12; 0)
	End if 
End if 