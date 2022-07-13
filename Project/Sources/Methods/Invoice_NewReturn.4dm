//%attributes = {"publishedWeb":true}
//PM:  Invoice_NewReturn(orderline;invoice;qty)  4/15/99  MLB
//instantiate a new credit memo, 
//return invoice number if success, 0 or negative if fail
//note that it is mandated that there be one invoice per Release
//called by Rpt_BillOfLadi2, replaces api_SendInvTran
//mlb 6/13/07 don't credit cartons that were shipped for free
// Modified by: Mel Bohince (11/4/20) rmv params 5 & 6 chg and \
//  change param 4 from 0 to [Customers_Invoices]ExtendedPrice fSalesCommission call

C_LONGINT:C283($params; $invoiceNum; $2; $0; $now; $qtyReturned; $qtyShippedFree)
C_TEXT:C284($1; $orderLine)
C_REAL:C285($3; $units)
$params:=Count parameters:C259
$now:=TSTimeStamp
C_DATE:C307($today)
$today:=TS2Date($now)
C_TEXT:C284($exception)
$exception:=""
//*Set up identity
Case of 
	: ($params=3)
		$orderLine:=$1
		$invoiceNum:=$2
		$qtyReturned:=$3*-1
		
	Else 
		$exception:="Invoice_NewReturn parameters missing. "
End case 

//*Bring into memory all the related records required
$exception:=$exception+Invoice_GetReturnRecords($orderLine)

//*Create the invoice
Invoice_New($invoiceNum)
[Customers_Invoices:88]BillOfLadingNumber:3:=0
//*Populate related fields
If (Length:C16($exception)=0)
	[Customers_Invoices:88]OrderLine:4:=$orderLine
	[Customers_Invoices:88]ReleaseNumber:5:=0
	[Customers_Invoices:88]CustomerID:6:=[Customers_Order_Lines:41]CustID:4
	[Customers_Invoices:88]SalesPerson:8:=[Customers_Order_Lines:41]SalesRep:34
	[Customers_Invoices:88]ShipTo:9:=""  //[OrderLines]defaultShipTo
	[Customers_Invoices:88]BillTo:10:=[Customers_Order_Lines:41]defaultBillto:23
	[Customers_Invoices:88]CustomersPO:11:=[Customers_Order_Lines:41]PONumber:21
	[Customers_Invoices:88]InvComment:12:="Credit for "+String:C10(-1*$qtyReturned)+" returned units has been applied."
	If (Substring:C12(sCriter12; 1; 1)="R")
		[Customers_Invoices:88]InvComment:12:=[Customers_Invoices:88]InvComment:12+" (Ref: RGA#"+sCriter12+")"
	Else 
		[Customers_Invoices:88]InvComment:12:=[Customers_Invoices:88]InvComment:12+" (Rel: "+sCriter12+")"
	End if 
	[Customers_Invoices:88]InvType:13:="Credit"  //mark this record as a credit/return for Dynamics
	[Customers_Invoices:88]ProductCode:14:=[Customers_ReleaseSchedules:46]ProductCode:11
	$qtyShippedFree:=Invoice_CheckForOverShipment(($orderLine+"@"))
	[Customers_Invoices:88]Quantity:15:=$qtyReturned-$qtyShippedFree
	$units:=[Customers_Invoices:88]Quantity:15
	[Customers_Invoices:88]PricePerUnit:16:=[Customers_Order_Lines:41]Price_Per_M:8
	[Customers_Invoices:88]PricingUOM:17:=[Finished_Goods:26]Acctg_UOM:29
	[Customers_Invoices:88]Terms:18:="CREDIT FOR RETURN"
	[Customers_Invoices:88]ExtendedPrice:19:=[Customers_Invoices:88]Quantity:15*[Customers_Invoices:88]PricePerUnit:16
	If ([Customers_Invoices:88]PricingUOM:17="M") | ([Customers_Invoices:88]PricingUOM:17="")  //treat as per thousand
		[Customers_Invoices:88]ExtendedPrice:19:=[Customers_Invoices:88]ExtendedPrice:19/1000
		$units:=$units/1000
	End if 
	[Customers_Invoices:88]ExtendedPrice:19:=Round:C94([Customers_Invoices:88]ExtendedPrice:19; 2)
	[Customers_Invoices:88]CustomerLine:20:=[Customers_ReleaseSchedules:46]CustomerLine:28
	
	[Customers_Invoices:88]CommissionPayable:21:=fSalesCommission("Normal"; [Customers_Invoices:88]OrderLine:4; $units; [Customers_Invoices:88]ExtendedPrice:19)  // Modified by: Mel Bohince (11/4/20) ;sCriterion5;i1)
	
	[Customers_Invoices:88]GL_CODE:23:=Invoice_getGLcode
	
	$0:=$invoiceNum
	
Else 
	$0:=-1
	[Customers_Invoices:88]InvComment:12:=$exception
End if 
SAVE RECORD:C53([Customers_Invoices:88])
REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
//