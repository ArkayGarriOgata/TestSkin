Case of 
	: (Form event code:C388=On Double Clicked:K2:5)
		Case of 
			: ([Customers_ReleaseSchedules:46]CustID:12="00074")
				Self:C308->:=4D_Current_date
				[Customers_ReleaseSchedules:46]user_date_2:49:=Add to date:C393([Customers_ReleaseSchedules:46]user_date_1:48; 0; 6; 0)
				
			: ([Customers_ReleaseSchedules:46]CustID:12="00765")
				Self:C308->:=4D_Current_date
				[Customers_ReleaseSchedules:46]user_date_2:49:=Add to date:C393([Customers_ReleaseSchedules:46]user_date_1:48; 0; 6; 0)
				
			: (ELC_isEsteeLauderCompany([Customers_ReleaseSchedules:46]CustID:12))
				Self:C308->:=4D_Current_date
				[Customers_ReleaseSchedules:46]Expedite:35:="rfm "+[Customers_ReleaseSchedules:46]Expedite:35
		End case 
		
	: (Form event code:C388=On Data Change:K2:15)
		Case of 
			: ([Customers_ReleaseSchedules:46]CustID:12="00074")
				[Customers_ReleaseSchedules:46]user_date_2:49:=Add to date:C393([Customers_ReleaseSchedules:46]user_date_1:48; 0; 6; 0)
				
			: ([Customers_ReleaseSchedules:46]CustID:12="00765")
				[Customers_ReleaseSchedules:46]user_date_2:49:=Add to date:C393([Customers_ReleaseSchedules:46]user_date_1:48; 0; 6; 0)
				
			: (ELC_isEsteeLauderCompany([Customers_ReleaseSchedules:46]CustID:12))
				[Customers_ReleaseSchedules:46]Expedite:35:="rfm "+[Customers_ReleaseSchedules:46]Expedite:35
		End case 
End case 

