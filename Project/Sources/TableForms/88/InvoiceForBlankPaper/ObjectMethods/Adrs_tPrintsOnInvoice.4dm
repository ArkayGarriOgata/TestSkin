
Adrs_tPrintsOnInvoice:=CorektBlank

READ ONLY:C145([Addresses:30])

If (Core_Query_UniqueRecordB(->[Addresses:30]ID:1; ->[Customers_Invoices:88]BillTo:10))
	Adrs_tPrintsOnInvoice:=[Addresses:30]PrintsOnInvoice:50
End if 

UNLOAD RECORD:C212([Addresses:30])
