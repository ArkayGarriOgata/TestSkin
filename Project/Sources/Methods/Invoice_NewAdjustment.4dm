//%attributes = {"publishedWeb":true}
//PM:  Invoice_NewAdjustment  4/15/99  MLB
//instantiate a new invoice, 
//make adjustment due to a cust change order
//return invoice number if success, 0 or negative if fail
//•061599  mlb  UPR 2049
//•061699  mlb  pass units to commission calc
// Modified by: Mel Bohince (1/9/19) pricing UOM based on s/b flag on orderline
C_TEXT:C284($1; $orderLine)
C_LONGINT:C283($params; $invoiceNum; $2; $0; $now)
C_TEXT:C284($comment; $3)
C_LONGINT:C283($4; $qty)
C_REAL:C285($units; $adjustRevenue; $5)
$params:=Count parameters:C259

C_TEXT:C284($exception)
$exception:=""
//*Set up identity
Case of 
	: ($params=5)
		$orderLine:=$1
		$invoiceNum:=$2
		$comment:=$3
		$qty:=$4
		$adjustRevenue:=$5
		
	Else 
		$exception:="Invoice_NewAdjustment parameters missing. "
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
	[Customers_Invoices:88]ShipTo:9:=""  //[OrderLines]defaultShipTo
	[Customers_Invoices:88]BillTo:10:=[Customers_Order_Lines:41]defaultBillto:23
	[Customers_Invoices:88]CustomersPO:11:=[Customers_Order_Lines:41]PONumber:21
	[Customers_Invoices:88]InvComment:12:=$comment
	// Modified by: Mel Bohince (12/23/19) set in trigger now
	//If ($qty>0)
	//[Customers_Invoices]InvType:="Debit"  //mark this record as a credit/return for Dynamics
	//Else 
	//[Customers_Invoices]InvType:="Credit"  //mark this record as a credit/return for Dynamics
	//End if 
	[Customers_Invoices:88]ProductCode:14:=[Customers_Order_Lines:41]ProductCode:5
	[Customers_Invoices:88]Quantity:15:=$qty
	$units:=[Customers_Invoices:88]Quantity:15
	If ($adjustRevenue>0)  //•6/09/99  MLB  
		[Customers_Invoices:88]Terms:18:=[Customers_Orders:40]Terms:23
	Else 
		[Customers_Invoices:88]Terms:18:="CREDIT FOR ADJUSTMENT"
	End if 
	[Customers_Invoices:88]ExtendedPrice:19:=$adjustRevenue
	//[Customers_Invoices]PricingUOM:=[Finished_Goods]Acctg_UOM
	// Modified by: Mel Bohince (1/9/19) Special Billings will ALWAYs be in Each, even if charging for a F/G such as when doing Liabilities.
	If ([Customers_Order_Lines:41]SpecialBilling:37)
		[Customers_Invoices:88]PricingUOM:17:="EA"
	Else 
		[Customers_Invoices:88]PricingUOM:17:="M"  //per thousand
		$units:=$units/1000
	End if 
	//If ([Customers_Invoices]PricingUOM="M") | ([Customers_Invoices]PricingUOM="")  //treat as per thousand
	//  //[Invoices]ExtendedPrice:=[Invoices]ExtendedPrice/1000
	//$units:=$units/1000
	//End if 
	[Customers_Invoices:88]PricePerUnit:16:=Round:C94($adjustRevenue/$units; 3)
	[Customers_Invoices:88]ExtendedPrice:19:=Round:C94([Customers_Invoices:88]ExtendedPrice:19; 2)
	[Customers_Invoices:88]CustomerLine:20:=[Customers_Order_Lines:41]CustomerLine:42
	//If ([Customers_Order_Lines]OrderNumber<commissionChange)
	//[Customers_Invoices]CommissionPlan:=commissionLastPln
	//End if 
	//[Invoices]CommissionPayable:=fSalesCommission ("Normal";[Invoices
	//«]OrderLine;$units;$adjustRevenue)
	Case of   //•061599  mlb  UPR 2049
		: (Position:C15("Freight"; [Customers_Invoices:88]ProductCode:14)=0) & ([Customers_Order_Lines:41]SpecialBilling:37)
			[Customers_Invoices:88]CommissionPayable:21:=fSalesCommission("SplBilling"; [Customers_Invoices:88]OrderLine:4; $units; $adjustRevenue)
		: ([Customers_Order_Lines:41]SpecialBilling:37)
			[Customers_Invoices:88]CommissionPayable:21:=fSalesCommission("Freight"; [Customers_Invoices:88]OrderLine:4; $units; $adjustRevenue)
		Else 
			[Customers_Invoices:88]CommissionPayable:21:=fSalesCommissionAdj([Customers_Invoices:88]OrderLine:4; $units; $adjustRevenue)
	End case 
	
	[Customers_Invoices:88]GL_CODE:23:=Invoice_getGLcode
	
	$0:=$invoiceNum
	
Else 
	$0:=-1
	[Customers_Invoices:88]InvComment:12:=$exception
End if 
SAVE RECORD:C53([Customers_Invoices:88])
REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
//