//%attributes = {}
// Method: Invoice_getBookedCost () -> 
// ----------------------------------------------------
// by: mel: 08/11/05, 15:25:41
// ----------------------------------------------------
// Description:
// return cogs at orderlines booked cost

// Updates:

// ----------------------------------------------------
C_REAL:C285($0)

If ([Customers_Order_Lines:41]OrderLine:3#$1)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$1)
End if 

If ([Customers_Invoices:88]InvoiceNumber:1#$2)
	QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]InvoiceNumber:1#$2)
End if 

$0:=[Customers_Order_Lines:41]Cost_Per_M:7*[Customers_Invoices:88]Quantity:15/1000
