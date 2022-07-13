//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/25/07, 15:16:35
// ----------------------------------------------------
// Method: CUST_isRamaProject_Swaps
// ----------------------------------------------------

[Customers_Invoices:88]PricePerUnit:16:=fGetSalesValue([Customers_Invoices:88]OrderLine:4; [Customers_Invoices:88]ProductCode:14)
[Customers_Invoices:88]InvComment:12:="Price to P&G is $"+String:C10([Customers_Order_Lines:41]Price_Per_M:8)+"/M. "+[Customers_Invoices:88]InvComment:12
Case of 
	: (Position:C15("Arkay Buffer"; [Customers_ReleaseSchedules:46]RemarkLine1:25)#0)
		[Customers_Invoices:88]Terms:18:="Net 150"
		[Customers_Invoices:88]BillTo:10:="02769"
	: (Position:C15("Rama Buffer"; [Customers_ReleaseSchedules:46]RemarkLine1:25)#0)
		[Customers_Invoices:88]Terms:18:="Net 120"
		[Customers_Invoices:88]BillTo:10:="02768"
	Else 
		[Customers_Invoices:88]Terms:18:="Net 90"
		[Customers_Invoices:88]BillTo:10:="02565"  //original code, swap billto, original terms
End case 