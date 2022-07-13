//%attributes = {"publishedWeb":true}
//Procedure: fProfitVariable($solveFor;cost;price;pv{;rebate})  061998  MLB
//calculate a component of the PV equation, give the other operands
//see also fGetCustRebate($custid{;brand}) 
//•062498  MLB  guard against division by zero, don't put up NAN alert, leave NAN
//•added truncate 3/29/11 so commission scale is consistent
//                                 cost
//  PV    =     1 -    --------------
//                          price(1-Rebate)

//                           cost
//                      -----------
//  price    =        (1  - PV)
//                    --------------
//                       (1-Rebate)
//
//  cost    =          price * (1-PV) * (1  - Rebate) 
//                         

C_REAL:C285($2; $cost; $3; $price; $4; $pv; $5; $rebate; $0; $solution)
C_TEXT:C284($1; $solveFor)
$solveFor:=$1
$cost:=$2
$price:=$3
$pv:=$4
If (Count parameters:C259=5)
	$rebate:=$5
Else 
	$rebate:=0
End if 
$solution:=0

Case of 
	: ($solveFor="PV")
		If ($price#0)  //•062498  MLB  
			$pv:=1-($cost/($price*(1-$rebate)))
		Else   //•062498  MLB  
			$pv:=-1
		End if 
		//$0:=Trunc($pv;2)  `see below, added truncate 3/29/11 so commission scale is consistent
		$solution:=$pv
		$0:=Num:C11(String:C10($solution; "###########0.00;-###########0.00;-0-"))
		
	: ($solveFor="price")
		If (($pv#1) & ($rebate#1))  //•062498  MLB  
			$price:=$cost/(1-$pv)/(1-$rebate)
		Else 
			$price:=0
		End if 
		$solution:=$price
		$0:=Round:C94($solution; 2)
		
	: ($solveFor="cost")
		$cost:=$price*(1-$pv)*(1-$rebate)
		$solution:=$cost
		$0:=Num:C11(String:C10($solution; "###########0.00;-###########0.00;-0-"))
		
	Else 
		BEEP:C151
		ALERT:C41($solveFor+" is unknown to fProfitVariable")
End case 
//
//ws didn't like the rounding of trunc
//$0:=Num(String($solution;"###########0.00;-###########0.00;-0-"))
