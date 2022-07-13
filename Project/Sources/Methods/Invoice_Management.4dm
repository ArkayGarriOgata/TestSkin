//%attributes = {"publishedWeb":true}
// _______
// Method: Invoice_Management   ( ) ->
// By: Mel Bohince @ 042099
// Description
// display a list of invoices to work with

QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Status:22="Pending")
If (Records in selection:C76([Customers_Invoices:88])<2)  //want the list to display
	QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Status:22="Pending"; *)
	QUERY:C277([Customers_Invoices:88];  | ; [Customers_Invoices:88]Status:22="Hold")
End if 

User_AllowedSelection(->[Customers_Invoices:88])
If (Records in selection:C76([Customers_Invoices:88])>0)
	<>PassThrough:=True:C214
	CREATE SET:C116([Customers_Invoices:88]; "◊PassThroughSet")
	REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
End if 

ViewSetter(2; ->[Customers_Invoices:88])
//