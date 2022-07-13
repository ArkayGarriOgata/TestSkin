//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 08/01/07, 15:02:42
// ----------------------------------------------------
// Method: ams_DeleteOldInvoices
// ----------------------------------------------------

C_DATE:C307($cutOff; $1)

$cutOff:=$1  //!04/01/01!

READ WRITE:C146([Customers_Invoices:88])
QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Invoice_Date:7<$cutOff)

util_DeleteSelection(->[Customers_Invoices:88])