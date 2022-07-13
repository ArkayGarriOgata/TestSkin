//%attributes = {"publishedWeb":true}
//PM: INV_getCommissionScale({custid;projectid;line}) -> scale#
//@author mlb - 8/31/01  12:53
// • mel (5/11/05, 11:41:12) chg so can be used from estimating
// • mel (8/11/05, 16:04:26) only scales 2,3,&4 will be active in 8/1/05 plan
//mlb 092105 added Non contract >18mth
// Modified by: Mel Bohince (1/8/13) BAD's spl commish
// Modified by: Mel Bohince (2/8/13) BAD's spl moved before promotional case
// Modified by: Mel Bohince (1/7/20) use CommissionPercent in customer record if available

C_LONGINT:C283($0; $scale)  //refers to the commission table used to determine rate
C_BOOLEAN:C305($promotional; $splBilling)
C_REAL:C285($fixedCommission)
C_TEXT:C284($custId; $pjtID; $1; $2; $special_commission)

$promotional:=False:C215
$fixedCommission:=-1
$scale:=0  //assume failure
$special_commission:=""
$simpleCommission:=False:C215  // Modified by: Mel Bohince (1/7/20) use CommissionPercent in customer record if available

If (Count parameters:C259=0)  // • mel (5/11/05, 11:41:12) chg so can be used from estimating
	$custId:=[Customers_Order_Lines:41]CustID:4
	$pjtID:=[Customers_Order_Lines:41]ProjectNumber:50
	$promoLine:=[Customers_Order_Lines:41]CustomerLine:42
	$splBilling:=[Customers_Order_Lines:41]SpecialBilling:37
Else 
	$custId:=$1
	$pjtID:=$2
	$promoLine:=$3
	$splBilling:=False:C215
End if 

If ([Customers:16]ID:1#$custId)
	READ ONLY:C145([Customers:16])
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=$custId)
	SET QUERY LIMIT:C395(0)
End if 
// Modified by: Mel Bohince (1/8/13) caseof below
Case of   //special commission structure for some salesman
		
	: ([Customers:16]CommissionPercent:50>0)  // Modified by: Mel Bohince (1/7/20) use CommissionPercent in customer record if available
		$simpleCommission:=True:C214
		
	: ([Customers:16]SalesmanID:3="BAD")
		$special_commission:="BAD"
	Else 
		$special_commission:=""
End case 


If ([Customers_Projects:9]id:1#$pjtID)
	READ ONLY:C145([Customers_Projects:9])
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=$pjtID)
	SET QUERY LIMIT:C395(0)
End if 

If (Records in selection:C76([Customers_Projects:9])>0)
	$promotional:=[Customers_Projects:9]PromotionalPjt:8
	$fixedCommission:=[Customers_Projects:9]FixedCommission:12
End if 

If (Not:C34($promotional))  //• mlb - 10/31/01  klugde for lazy planners
	If (Position:C15("promo"; $promoLine)>0)
		$promotional:=True:C214
	End if 
End if 

Case of 
	: ($splBilling)
		$scale:=-1
		
	: ($simpleCommission)  // Modified by: Mel Bohince (1/7/20) 
		$scale:=-2
		
		// Modified by: Mel Bohince (1/8/13)
	: ($special_commission="BAD")  //same on contract work, different on New work
		Case of 
			: ($promotional)
				$scale:=5
				//first check project
			: ([Customers_Projects:9]CommissionType:14="Big Contract")  //• mlb - 3/12/03  16:39
				$scale:=2
			: ([Customers_Projects:9]CommissionType:14="Small Contract")
				$scale:=3
			: ([Customers_Projects:9]CommissionType:14="New")
				$scale:=5
				//next check customers
			: ([Customers:16]CustomerType:54="Big Contract")  //• mlb - 3/12/03  16:39
				$scale:=2
			: ([Customers:16]CustomerType:54="Small Contract")
				$scale:=3
			: ([Customers:16]CustomerType:54="New")
				$scale:=5
		End case 
		
	: ($promotional)
		$scale:=4
		
	: ($fixedCommission>0)  //& (False)
		$scale:=1  //••••••
		
		//first check project
	: ([Customers_Projects:9]CommissionType:14="Big Contract")  //• mlb - 3/12/03  16:39
		$scale:=2
	: ([Customers_Projects:9]CommissionType:14="Small Contract")
		$scale:=3
	: ([Customers_Projects:9]CommissionType:14="New")
		$scale:=4
		
		//next check customers
	: ([Customers:16]CustomerType:54="Big Contract")  //• mlb - 3/12/03  16:39
		$scale:=2
	: ([Customers:16]CustomerType:54="Small Contract")
		$scale:=3
	: ([Customers:16]CustomerType:54="New")
		$scale:=4
		
	Else   //use lowest scale if not determined
		$scale:=3
End case 

$0:=$scale