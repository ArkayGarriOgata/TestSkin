//%attributes = {"publishedWeb":true}
//PM: INV_getTermsCode(verbose terms) -> 2character code
//@author mlb - 8/3/01  14:32
// • mel (4/26/05, 13:50:31) chg the X%15NetY to Y days

C_TEXT:C284($1; $aMsTerm)
C_TEXT:C284($0)

$aMsTerm:=Replace string:C233($1; " "; "")
$aMsTerm:=Replace string:C233($aMsTerm; ","; "")
$aMsTerm:=Replace string:C233($aMsTerm; "-"; "")
$aMsTerm:=Replace string:C233($aMsTerm; "/"; "")
$aMsTerm:=Replace string:C233($aMsTerm; "Days"; "")

Case of 
	: ($aMsTerm="Net30") | ($aMsTerm="30")
		$0:="30"
		
	: ($aMsTerm="Net45") | ($aMsTerm="45")
		$0:="45"
		
	: ($aMsTerm="Net50") | ($aMsTerm="50")
		$0:="50"
		
	: ($aMsTerm="Net60") | ($aMsTerm="60")
		$0:="60"
		
	: ($aMsTerm="Net90") | ($aMsTerm="90")
		$0:="90"
		
	: ($aMsTerm="Net120") | ($aMsTerm="120")
		$0:="120"
		
	: ($aMsTerm="Net150") | ($aMsTerm="150")
		$0:="99"
		
	: ($aMsTerm="131313")
		$0:="33"
		
	: ($aMsTerm="13dueNet30")
		$0:="30"
		
	: ($aMsTerm="1%15Net30")
		$0:="30"
		
	: ($aMsTerm="1%15Net45")
		$0:="45"
		
	: ($aMsTerm="2%15Net45")
		$0:="45"
		
	: ($aMsTerm="1%10Net30")
		$0:="30"
		
	: ($aMsTerm="OnReceipt")
		$0:="0"
		
	Else 
		$0:="0"
End case 