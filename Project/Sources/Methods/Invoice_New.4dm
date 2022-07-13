//%attributes = {"publishedWeb":true}
//PM:  Invoice_New 5/06/99  MLB
//do what is common to all new invoices here
//•052899  mlb  UPR 236 set commissionChange:=86000 instead of 90000
C_LONGINT:C283($now; $invoiceNum; $1; $2)
$invoiceNum:=$1
$now:=TSTimeStamp
C_DATE:C307($today)
$today:=TS2Date($now)
CREATE RECORD:C68([Customers_Invoices:88])
[Customers_Invoices:88]InvoiceNumber:1:=$invoiceNum
[Customers_Invoices:88]tsTimeStamp:2:=$now
[Customers_Invoices:88]Invoice_Date:7:=$today
[Customers_Invoices:88]Status:22:="Pending"
[Customers_Invoices:88]AmountPaid:24:=0
[Customers_Invoices:88]CommissionPaid:25:=0
[Customers_Invoices:88]CommissionPlan:26:="2020"  //chgs to planned cost, not fifo actual & some fixed percents
//commissionChange:=10000  //if lower than this number, use old plan
//commissionLastPln:="2020"

If (Count parameters:C259>1)
	SAVE RECORD:C53([Customers_Invoices:88])
End if 
//