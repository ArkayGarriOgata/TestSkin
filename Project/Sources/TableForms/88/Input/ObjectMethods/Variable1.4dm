
[Customers_Invoices:88]Terms:18:=util_ComboBoxAction(->aInvoTerms; aInvoTerms{0})

dDate:=Invoice_GetDateDue([Customers_Invoices:88]Terms:18; [Customers_Invoices:88]Invoice_Date:7)

If ([Customers_Invoices:88]Terms:18#"")
	GOTO OBJECT:C206([Customers_Invoices:88]ProductCode:14)
End if 