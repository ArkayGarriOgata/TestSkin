//%attributes = {"publishedWeb":true}
//Method: fSalesCommission("SalesRep";Orderline;QuantityInPricingUnits)  040999  M
//calculate Sales Commission
//•4/15/99  MLB  UPR tidy up
//•5/05/99  MLB  reverse commissions on credits
//•052499  mlb  MJH and MSK want special cases
//•052499  mlb  MJH wants planned cost, not booked cost
//•052599  mlb  revised contract commission
//•060499  mlb  UPR 236 revise payuse commission cost basis
//•6/09/99  MLB  get correct return cost, default to booked cost
//071800 permit zero cost
//071900 store CoGS,PV,Contract used in the invoice record
// • mel (8/17/05, 10:04:55) `activate new commish plan as of 08/18/05
// Modified by: Mel Bohince (6/6/11) force pv to match contract if available
// Modified by: Mel Bohince (1/16/19) no commission on liability orders, based on invoice comment field
// Modified by: Mel Bohince (11/5/20) rmv old comments and unused params $5 & $6
// Modified by: Mel Bohince (12/4/20) make Recalc btn on invoice compliant

//sets:
// [Customers_Invoices]CoGS
// [Customers_Invoices]ProfitVariable
// [Customers_Invoices]CommissionScale
// [Customers_Invoices]CommissionPercent
// [Customers_Invoices]QtyShipOver9Months
// [Customers_Invoices]z_obsolete_ws

C_TEXT:C284($invoiceType; $1)
C_REAL:C285($3; $units; $revenue; $4)  //•4/15/99  MLB  qty not integer
C_REAL:C285($cost; $rebate; $pv; $percentCommission; $commission; $0; $temp)
$invoiceType:=$1  //can be overriden by orderlines' spl billing field and freight in product code
$commission:=0
$units:=$3
$temp:=0
$percentCommission:=0

If ([Customers_Order_Lines:41]OrderLine:3#$2)
	SET QUERY LIMIT:C395(1)
	READ ONLY:C145([Customers_Order_Lines:41])
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$2)
	SET QUERY LIMIT:C395(0)
End if 

If ([Customers_Order_Lines:41]SpecialBilling:37)  // Modified by: Mel Bohince (12/4/20) make Recalc btn on invoice compliant
	If (Position:C15("freight"; [Customers_Order_Lines:41]ProductCode:5)=0)
		$invoiceType:="SplBilling"
	Else 
		$invoiceType:="Freight"
	End if 
End if 

If (Count parameters:C259<4)
	$revenue:=Round:C94([Customers_Order_Lines:41]Price_Per_M:8*$units; 2)
Else 
	$revenue:=$4
End if 

$cost:=0
Case of   //determine (extended) cost
	: ($invoiceType="Freight") | ($invoiceType="SplBilling")
		$cost:=0  //cost not needed
		
	: ([Customers_Invoices:88]ReleaseNumber:5#0)  //•060499  mlb  UPR 236
		Case of 
			: (False:C215)  //• mlb - 6/20/01  
				$cost:=Invoice_getPlannedCost([Customers_Order_Lines:41]OrderLine:3; [Customers_Invoices:88]ReleaseNumber:5)
			: (True:C214)  //as of 08/18/05
				$cost:=Invoice_getBookedCost([Customers_Order_Lines:41]OrderLine:3; [Customers_Invoices:88]InvoiceNumber:1)  // • mel (8/11/05, 15:30:32)
			Else   //fifo'd cost
				QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=([Customers_Order_Lines:41]OrderLine:3+"/"+String:C10([Customers_Invoices:88]ReleaseNumber:5)))  //[Bills_of_Lading]Manifest'Arkay_Release)))
				If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
					$cost:=Sum:C1([Finished_Goods_Transactions:33]CoGSExtended:8)
				End if 
		End case 
		
	: (Position:C15("RETURN"; [Customers_Invoices:88]Terms:18)#0)  //•6/09/99  MLB  UPR 236
		$index:=Position:C15("RGA#"; [Customers_Invoices:88]InvComment:12)
		If ($index>0)
			$cost:=Invoice_getBookedCost([Customers_Order_Lines:41]OrderLine:3; [Customers_Invoices:88]InvoiceNumber:1)
			
		Else 
			$cost:=0
		End if 
		
	: ([Customers_Order_Lines:41]PayUse:47)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=([Customers_Order_Lines:41]OrderLine:3+"/PayU"+String:C10([Customers_Invoices:88]InvoiceNumber:1)))
		If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
			$cost:=Sum:C1([Finished_Goods_Transactions:33]CoGSExtended:8)
		End if 
		
	Else   //use booked cost
		$cost:=Round:C94([Customers_Order_Lines:41]Cost_Per_M:7*$units; 2)
End case 
[Customers_Invoices:88]CoGS:27:=Round:C94($cost; 2)

//determine the commission and rate
Case of 
	: ($invoiceType="Freight")  //•052499  mlb  MJH and MSK want special cases
		$commission:=0  //no commission
		[Customers_Invoices:88]CommissionScale:30:=0
		[Customers_Invoices:88]CommissionPercent:31:=0
		
	: ($invoiceType="SplBilling")  //•052499  mlb  MJH and MSK want special cases
		If (Position:C15("liabil"; [Customers_Invoices:88]InvComment:12)=0)  //not a liability invoice
			$commission:=$revenue*0.01  //fixed at 1%
			[Customers_Invoices:88]CommissionPercent:31:=0.01
			[Customers_Invoices:88]ProfitVariable:28:=0.01
			[Customers_Invoices:88]CommissionScale:30:=-1
			
		Else   //treat as liability
			$commission:=0  // Modified by: Mel Bohince (1/16/19) no commission on liabilites
			[Customers_Invoices:88]CommissionPercent:31:=0
			[Customers_Invoices:88]ProfitVariable:28:=0
			[Customers_Invoices:88]CommissionScale:30:=-4
		End if 
		
	Else 
		
		$rebate:=0  //fGetCustRebate ([Customers_Order_Lines]CustID)// Modified by: Mel Bohince (1/7/20) rebates havnt been used in a long time, disable
		
		If (Count parameters:C259=4)  //base pv on unit cost and price
			$temp:=$revenue
			$revenue:=Round:C94([Customers_Order_Lines:41]Price_Per_M:8*$units; 2)
		End if 
		$pv:=fProfitVariable("PV"; $cost; $revenue; $pv; $rebate)  //•052499  mlb switch to extend cost & price
		
		// Modified by: Mel Bohince (6/6/11) force pv to match contract if available
		If (ELC_isEsteeLauderCompany([Customers_Invoices:88]CustomerID:6))
			$contractPV:=ELC_getContractPV([Customers_Invoices:88]CustomerID:6; [Customers_Invoices:88]CustomerLine:20)
			If ($contractPV#$pv) & ($contractPV#0)
				$pv:=$contractPV
			End if 
		End if 
		[Customers_Invoices:88]ProfitVariable:28:=$pv
		
		If (Count parameters:C259=4)
			$revenue:=$temp
		End if 
		$percentCommission:=0
		
		$scale:=INV_getCommissionScale
		[Customers_Invoices:88]CommissionScale:30:=$scale
		$percentCommission:=INV_useScale($scale; $pv)
		[Customers_Invoices:88]CommissionPercent:31:=$percentCommission
		$commission:=$revenue*$percentCommission
		
		[Customers_Invoices:88]QtyShipOver9Months:36:=Invoice_getQuantityofOld([Customers_Order_Lines:41]OrderLine:3; [Customers_Invoices:88]ReleaseNumber:5; [Customers_Invoices:88]Invoice_Date:7)
		If (True:C214)  //as of 08/18/05
			If ([Customers_Invoices:88]QtyShipOver9Months:36>0) & ([Customers_Invoices:88]Quantity:15>0)
				If ([Customers_Invoices:88]QtyShipOver9Months:36>[Customers_Invoices:88]Quantity:15)
					[Customers_Invoices:88]QtyShipOver9Months:36:=[Customers_Invoices:88]Quantity:15
				End if 
				$reductionForAge:=1-([Customers_Invoices:88]QtyShipOver9Months:36/[Customers_Invoices:88]Quantity:15)
				$commission:=$commission*$reductionForAge
			End if 
		End if 
		
		[Customers_Invoices:88]z_obsolete_ws:32:=$revenue*INV_getWaltersCommission
		
End case 

$0:=Round:C94($commission; 2)
//