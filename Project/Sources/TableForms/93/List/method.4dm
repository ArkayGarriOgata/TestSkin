
Case of 
	: (Form event code:C388=On Load:K2:1)
		If (User in group:C338(Current user:C182; "SalesManager")) | (User in group:C338(Current user:C182; "RoleAccounting"))
			SetObjectProperties("S@"; -><>NULL; True:C214)
		Else 
			SetObjectProperties("S@"; -><>NULL; False:C215)
		End if 
		
End case 

