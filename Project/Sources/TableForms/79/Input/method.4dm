
Case of 
	: (Form event code:C388=On Load:K2:1)
		If (iMode=2)
			OBJECT SET ENABLED:C1123(bDelete; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bDelete; False:C215)
		End if 
		
End case 

