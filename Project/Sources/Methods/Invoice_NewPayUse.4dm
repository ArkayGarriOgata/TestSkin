//%attributes = {"publishedWeb":true}
//PM:  Invoice_NewPayUse(orderline;invoice#;comment;qty)  4/15/99  MLB
//instantiate a new invoice, 
//return invoice number if success, 0 or negative if fail
//note that it is mandated that there be one invoice per Release
//called by Rpt_BillOfLadi2, replaces api_SendInvTran
//•060499  mlb  UPR 236 add payuse usedate or cust refer to PO
C_TEXT:C284($1; $orderLine)
C_LONGINT:C283($params; $invoiceNum; $2; $0; $now)
C_TEXT:C284($comment; $3; $5; $reference)
C_LONGINT:C283($4; $qty)

C_REAL:C285($units)
$params:=Count parameters:C259
$now:=TSTimeStamp
C_DATE:C307($today)
$today:=TS2Date($now)
C_TEXT:C284($exception)
$exception:=""
//*Set up identity
Case of 
	: ($params=5)
		$orderLine:=$1
		$invoiceNum:=$2
		$comment:=$3
		$qty:=$4
		$reference:=$5  //•060499  mlb  UPR 236 add payuse usedate or cust refer to PO
	Else 
		$exception:="Invoice_NewConsignment parameters missing. "
End case 

//*Bring into memory all the related records required
$exception:=$exception+Invoice_GetPayUseRecords($orderLine)

//*Create the invoice
Invoice_New($invoiceNum)
[Customers_Invoices:88]BillOfLadingNumber:3:=0  //$BOL
//*Populate related fields
If (Length:C16($exception)=0)
	[Customers_Invoices:88]OrderLine:4:=[Customers_Order_Lines:41]OrderLine:3
	[Customers_Invoices:88]ReleaseNumber:5:=0  //[Bills_of_Lading]Manifest'Arkay_Release
	[Customers_Invoices:88]CustomerID:6:=[Customers_Order_Lines:41]CustID:4
	[Customers_Invoices:88]SalesPerson:8:=[Customers_Order_Lines:41]SalesRep:34
	[Customers_Invoices:88]ShipTo:9:=[Customers_Order_Lines:41]defaultShipTo:17
	[Customers_Invoices:88]BillTo:10:=[Customers_Order_Lines:41]defaultBillto:23
	[Customers_Invoices:88]CustomersPO:11:=[Customers_Order_Lines:41]PONumber:21+" "+$reference  //•060499  mlb  UPR 236 add payuse usedate or cust refer to PO
	[Customers_Invoices:88]InvComment:12:=$comment
	[Customers_Invoices:88]InvType:13:="Debit"  //mark this record as a credit/return for Dynamics
	[Customers_Invoices:88]ProductCode:14:=[Customers_Order_Lines:41]ProductCode:5
	[Customers_Invoices:88]Quantity:15:=$qty
	$units:=[Customers_Invoices:88]Quantity:15
	[Customers_Invoices:88]PricePerUnit:16:=[Customers_Order_Lines:41]Price_Per_M:8
	[Customers_Invoices:88]PricingUOM:17:=[Finished_Goods:26]Acctg_UOM:29
	[Customers_Invoices:88]Terms:18:=[Customers_Orders:40]Terms:23
	[Customers_Invoices:88]ExtendedPrice:19:=[Customers_Invoices:88]Quantity:15*[Customers_Invoices:88]PricePerUnit:16
	If ([Customers_Invoices:88]PricingUOM:17="M") | ([Customers_Invoices:88]PricingUOM:17="")  //treat as per thousand
		[Customers_Invoices:88]ExtendedPrice:19:=[Customers_Invoices:88]ExtendedPrice:19/1000
		$units:=$units/1000
	End if 
	[Customers_Invoices:88]ExtendedPrice:19:=Round:C94([Customers_Invoices:88]ExtendedPrice:19; 2)
	[Customers_Invoices:88]CustomerLine:20:=[Customers_Order_Lines:41]CustomerLine:42
	//If ([Customers_Order_Lines]OrderNumber<commissionChange)
	//[Customers_Invoices]CommissionPlan:=commissionLastPln
	//End if 
	[Customers_Invoices:88]CommissionPayable:21:=fSalesCommission("Normal"; [Customers_Invoices:88]OrderLine:4; $units)
	
	[Customers_Invoices:88]GL_CODE:23:=Invoice_getGLcode
	
	$0:=$invoiceNum
	
Else 
	$0:=-1
	[Customers_Invoices:88]InvComment:12:=$exception
End if 
SAVE RECORD:C53([Customers_Invoices:88])
REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
//