uConfirm("Print invoice on preprinted form or blank paper?"; "Preprinted"; "Blank")
If (ok=1)
	FORM SET OUTPUT:C54([Customers_Invoices:88]; "InvoiceForPreprintedForm")
Else 
	FORM SET OUTPUT:C54([Customers_Invoices:88]; "InvoiceForBlankPaper")
End if 

PRINT RECORD:C71([Customers_Invoices:88])  //•061599  mlb  show print dialogs
FORM SET OUTPUT:C54([Customers_Invoices:88]; "List")