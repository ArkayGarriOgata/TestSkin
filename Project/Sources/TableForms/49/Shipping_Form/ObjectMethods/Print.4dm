// _______
// Method: [Customers_Bills_of_Lading].Shipping_Form.OldPrintButton   ( ) ->
// User name (OS): mel
// Date and time: 05/08/07, 16:32:14
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

//If (False)
//utl_Logfile ("debug.log";"##PRINTING: BOL# "+String([Customers_Bills_of_Lading]ShippersNo))
BOL_PrintBillOfLading
//utl_Logfile ("debug.log";"##Finished: BOL# "+String([Customers_Bills_of_Lading]ShippersNo))
//End if 

If ([Customers_Bills_of_Lading:49]WasBilled:29)
	SetObjectProperties(""; ->bOK; True:C214; "Reprint")
	SetObjectProperties(""; ->bPrint; True:C214; "Reprint")
Else 
	SetObjectProperties(""; ->bOK; True:C214; "Print")
	SetObjectProperties(""; ->bPrint; True:C214; "Print")
End if 

QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]BillOfLadingNumber:3=[Customers_Bills_of_Lading:49]ShippersNo:1)
ORDER BY:C49([Customers_Invoices:88]; [Customers_Invoices:88]InvoiceNumber:1; >)