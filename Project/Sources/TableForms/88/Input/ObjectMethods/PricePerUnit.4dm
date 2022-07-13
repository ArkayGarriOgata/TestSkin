[Customers_Invoices:88]ExtendedPrice:19:=[Customers_Invoices:88]Quantity:15*[Customers_Invoices:88]PricePerUnit:16
If ([Customers_Invoices:88]PricingUOM:17="M")
	[Customers_Invoices:88]ExtendedPrice:19:=[Customers_Invoices:88]ExtendedPrice:19/1000
End if 