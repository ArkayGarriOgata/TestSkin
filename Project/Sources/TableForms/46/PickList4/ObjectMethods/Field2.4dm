If ([Customers:16]ID:1#[Customers_ReleaseSchedules:46]CustID:12)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_ReleaseSchedules:46]CustID:12)
End if 

If ([Customers:16]ReCertRequired:38)
	tRecert:=[Customers:16]Name:2+"  RE-CERTIFICATION REQUIRED - DONE BY: _____________"
Else 
	tRecert:=[Customers:16]Name:2
End if 
//