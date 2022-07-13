If (ELC_isEsteeLauderCompany([Customers_ReleaseSchedules:46]CustID:12))
	
	Case of 
		: (Form event code:C388=On Double Clicked:K2:5)
			Self:C308->:=Current date:C33
			[Customers_ReleaseSchedules:46]Expedite:35:="mr"
			
			
		: (Form event code:C388=On Data Change:K2:15)
			[Customers_ReleaseSchedules:46]Expedite:35:="mr"
	End case 
	
	If ([Customers_ReleaseSchedules:46]Expedite:35="mr")
		EDIT ITEM:C870([Customers_ReleaseSchedules:46]Mode:56)
	End if 
	
End if 

