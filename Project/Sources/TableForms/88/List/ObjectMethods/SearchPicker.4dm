//Searchpicker sample code

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		// Init the var itself
		// this can be done anywhere else in your code
		C_TEXT:C284(vSearch)
		vSearch:=""
		C_BOOLEAN:C305(useFindWidget)
		
		// the let's customise the SearchPicker (if needed)
		C_TEXT:C284($ObjectName)
		$ObjectName:=OBJECT Get name:C1087(Object current:K67:2)
		SearchPicker SET HELP TEXT($ObjectName; "Inv# Stat PO Line")
		
	: (Form event code:C388=On Data Change:K2:15)
		Case of 
			: (Not:C34(useFindWidget))
				useFindWidget:=True:C214  //toggle, coming from legacy [zz_control];"Select_dio"
				
			: (Length:C16(vSearch)>0)
				$criterian:="@"+vSearch+"@"
				C_LONGINT:C283($invoiceNumber)
				$invoiceNumber:=Num:C11(vSearch)
				QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]InvoiceNumber:1=$invoiceNumber; *)
				QUERY:C277([Customers_Invoices:88];  | ; [Customers_Invoices:88]Status:22=$criterian; *)
				QUERY:C277([Customers_Invoices:88];  | ; [Customers_Invoices:88]CustomersPO:11=$criterian; *)
				QUERY:C277([Customers_Invoices:88];  | ; [Customers_Invoices:88]ProductCode:14=$criterian; *)
				QUERY:C277([Customers_Invoices:88];  | ; [Customers_Invoices:88]CustomerLine:20=$criterian)
				
			Else 
				ALL RECORDS:C47([Customers_Invoices:88])
		End case 
		
		ORDER BY:C49([Customers_Invoices:88]; [Customers_Invoices:88]InvoiceNumber:1; >)
		
End case 
