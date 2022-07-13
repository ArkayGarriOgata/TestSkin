If (pjtId#"")
	User_SetAccess(->[Customers_Projects:9]; ->pjtId)
Else 
	User_SetAccess(->[Customers:16]; ->pjtCustid)
End if 