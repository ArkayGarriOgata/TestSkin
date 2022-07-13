QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=[Customers_Invoices:88]ReleaseNumber:5)
If ([Customers_Invoices:88]CustomersPO:11#[Customers_ReleaseSchedules:46]CustomerRefer:3)
	tText:=[Customers_ReleaseSchedules:46]CustomerRefer:3
Else 
	tText:=""
End if 