//zoomCust (->[Jobs]CustID)
If (Length:C16([Jobs:15]CustID:2)>0)
	pattern_PassThru(->[Customers:16])
	ViewSetter(iMode; ->[Customers:16])
Else 
	BEEP:C151
End if 
