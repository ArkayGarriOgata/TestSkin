//%attributes = {"publishedWeb":true}
//PM: INV_useScale($scale;pv) -> commissionRate
//@author mlb - 8/31/01  13:03 called by fSalesCommission
// • mel (5/11/05, 11:41:12) chg so can be used from estimating
// • mel (8/11/05, 15:50:27) new rates apply to only
// • mel (3/13/08) new rates
// Modified by: Mel Bohince (1/8/13) bill danylko spl scale
//"Big Contract"
//"Small Contract"
//"New" and promotional
// Modified by: Mel Bohince (1/7/20) use CommissionPercent in customer record if available

C_LONGINT:C283($scale; $1)
C_REAL:C285($commissionRate; $0; $2; $pv)

$scale:=$1
$pv:=$2
$commissionRate:=0

If (Count parameters:C259<=2)  // • mel (5/11/05, 11:41:12) chg so can be used from estimating
	$pjtID:=[Customers_Order_Lines:41]ProjectNumber:50
Else 
	$pjtID:=$3
End if 


Case of 
	: ($scale=-1)  //specialbilling
		$commissionRate:=0.01
		
	: ($scale=-2)  // Modified by: Mel Bohince (1/7/20) use CommissionPercent in customer record if available
		$commissionRate:=fSalesCommisionFlatRate([Customers_Invoices:88]CustomerID:6)
		
	: ($scale=1)  //& (False)  `Scale 1 - Fixed rate
		READ ONLY:C145([Customers_Projects:9])
		QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=$pjtID)
		If (Records in selection:C76([Customers_Projects:9])>0)
			$commissionRate:=[Customers_Projects:9]FixedCommission:12
		Else 
			$commissionRate:=0
		End if 
		
	: ($scale=2)  //Scale 2 - Contract Sales Over $3 million
		Case of 
			: ($pv<0.25)
				$commissionRate:=0
			: ($pv<0.3)
				$commissionRate:=0.01
			: ($pv<0.4)
				$commissionRate:=0.015
			: ($pv<0.5)
				$commissionRate:=0.02
			Else 
				$commissionRate:=0.025
		End case 
		
	: ($scale=3)  // Scale 3 - Contract Sales Up To $3 million
		Case of 
			: ($pv<0.25)  //new
				$commissionRate:=0
			: ($pv<0.3)  //new
				$commissionRate:=0.005
			: ($pv<0.4)  //new
				$commissionRate:=0.01
			: ($pv<0.5)  //new
				$commissionRate:=0.015
			Else 
				$commissionRate:=0.02
		End case 
		
	: ($scale=4)  //Scale 4 - New Customer or Promotion
		Case of 
			: ($pv<0.25)  //new
				$commissionRate:=0
			: ($pv<0.3)  //new
				$commissionRate:=0.01
			: ($pv<0.36)
				$commissionRate:=0.03
			: ($pv<0.41)
				$commissionRate:=0.04
			: ($pv<0.46)
				$commissionRate:=0.05
			: ($pv<0.5)
				$commissionRate:=0.06
			Else 
				$commissionRate:=0.07  //new
		End case 
		// Modified by: Mel Bohince (1/8/13)
	: ($scale=5)  //Scale 5 - Bill Danylko New Customer or Promotion  see 259549 1/15/13 0002 blis
		Case of 
			: ($pv<0.2)  //new
				$commissionRate:=0
			: ($pv<0.25)  //new
				$commissionRate:=0.005
			: ($pv<0.3)  //new
				$commissionRate:=0.015
			: ($pv<0.35)
				$commissionRate:=0.025
			: ($pv<0.4)
				$commissionRate:=0.035
			: ($pv<0.45)
				$commissionRate:=0.045
			: ($pv<0.5)
				$commissionRate:=0.055
			Else 
				$commissionRate:=0.06  //new
		End case 
		
End case 

$0:=$commissionRate