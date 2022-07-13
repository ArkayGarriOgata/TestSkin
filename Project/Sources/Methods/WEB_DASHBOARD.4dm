//%attributes = {}
// _______
// Method: WEB_DASHBOARD   ( ) ->
// By: angelo @ 10/18/19, 14:24:37
// Description
// 
// ----------------------------------------------------

C_DATE:C307(lastDate)
C_OBJECT:C1216(sales30Days; paid30Days; paidYear)
vtTitle:="Dashboard"
numCustomers:=44
numProducts:=1000
lastDate:=!00-00-00!

//sales30Days:=ds.INVOICES.query("Invoice_Date >= :1";lastDate-30)
//paid30Days:=ds.INVOICES.query("Payment_Date >= :1";lastDate-30)
//paidYear:=ds.INVOICES.query("Payment_Date >= :1";!2019-01-01!)

WEB SEND FILE:C619("/shuttle/dashboard.html")