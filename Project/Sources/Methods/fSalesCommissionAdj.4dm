//%attributes = {"publishedWeb":true}
//PM:  fSalesCommissionAdj  061599  mlb UPR 2049

//calculate an adjustment to commission because 

//of an adjustment to the price on an orderline

//•061699  mlb  pass units to commission calc

//• mlb - 10/10/01  16:19, change to 08'01 comm plan

//TRACE

C_REAL:C285($0; $newCommission; $oldCommission; $adjustment; $oldRevenue; $newRevenue; $2; $units; $cost; $commission; $rebate; $pv; $percentCommission)
$units:=$2
$adjustment:=$3
C_TEXT:C284($1; $orderline)
$orderline:=$1
If ([Customers_Order_Lines:41]OrderLine:3#$orderline)
	SET QUERY LIMIT:C395(1)
	READ ONLY:C145([Customers_Order_Lines:41])
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$orderline)
	SET QUERY LIMIT:C395(0)
End if 
$percentCommission:=0
//*Get the the commission paid so far

$oldCommission:=0
SAVE RECORD:C53([Customers_Invoices:88])
$currentInvoice:=[Customers_Invoices:88]InvoiceNumber:1
PUSH RECORD:C176([Customers_Invoices:88])
QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]OrderLine:4=$1; *)
QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]InvoiceNumber:1#$currentInvoice)
$oldAvgUnitCost:=0
If (Records in selection:C76([Customers_Invoices:88])>0)
	$oldCommission:=Sum:C1([Customers_Invoices:88]CommissionPayable:21)
	$oldRevenue:=Sum:C1([Customers_Invoices:88]ExtendedPrice:19)
	$oldCoGS:=Sum:C1([Customers_Invoices:88]CoGS:27)
	$oldQty:=Sum:C1([Customers_Invoices:88]Quantity:15)
	$oldAvgUnitCost:=$oldCoGS/$oldQty*1000
End if 
POP RECORD:C177([Customers_Invoices:88])
ONE RECORD SELECT:C189([Customers_Invoices:88])


//*    get the revenue

$newRevenue:=$oldRevenue+$adjustment

//*    get the cost

//$cost:=[OrderLines]Cost_Per_M*$units  `booked cost

$cost:=$oldAvgUnitCost*$units  // • mel (12/18/03 can't used booked cost


//*    calc the new commission

$rebate:=fGetCustRebate([Customers_Order_Lines:41]CustID:4)
$pv:=fProfitVariable("PV"; $cost; $newRevenue; $pv; $rebate)

//*Calculate the new total commission due

$newCommission:=0
$percentCommission:=0
If ([Customers_Orders:40]OrderNumber:1#[Customers_Order_Lines:41]OrderNumber:1)
	READ ONLY:C145([Customers_Orders:40])
	RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)
End if 

//If ([CustomerOrder]IsContract)

//Case of 

//: ($pv<=0.2)

//$percentCommission:=0

//: ($pv<0.4)

//$percentCommission:=0.005

//Else 

//$percentCommission:=0.015

//End case 


//Else   `regular business

//Case of 

//: ($pv<0.21)

//$percentCommission:=0

//: ($pv<0.28)

//$percentCommission:=0.01

//: ($pv<0.35)

//$percentCommission:=0.02

//: ($pv<0.4)

//$percentCommission:=0.03

//Else 

//$percentCommission:=0.04

//End case 

//End if 

//$newCommission:=Round($newRevenue*$percentCommission;2)


$scale:=INV_getCommissionScale
[Customers_Invoices:88]CommissionScale:30:=$scale
$percentCommission:=INV_useScale($scale; $pv)
[Customers_Invoices:88]CommissionPercent:31:=$percentCommission
$newCommission:=Round:C94($newRevenue*$percentCommission; 2)
//*Pay the difference

$0:=$newCommission-$oldCommission
//$0:=-0.02

//