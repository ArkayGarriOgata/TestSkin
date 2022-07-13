
Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Not:C34(User_AllowedCustomer([Customers_Bookings:93]Custid:1; ""; "via cust:"+[Customers_Bookings:93]CustomerName:18)))
			bDone:=1
			CANCEL:C270
		End if 
		
End case 

