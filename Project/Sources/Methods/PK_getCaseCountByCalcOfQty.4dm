//%attributes = {}
// _______
// Method: PK_getCaseCountByCalcOfQty   ( qty ; casePacking {;bias }) -> numCases
// By: Mel Bohince @ 03/23/21, 08:43:21
// Description
// rtn number of cases, if odd lot, round up the cases
// unless 3rd param says "case", then just send a multiple 
// of normal cases
// ----------------------------------------------------


C_LONGINT:C283($qty; $1; $packAt; $2)
C_REAL:C285($0; $cases)
C_TEXT:C284($bias; $3)

If (Count parameters:C259>0)
	$qty:=$1
	$packAt:=$2
	
	If (Count parameters:C259=3)  //user specified formula
		$bias:=$3
		
	Else   //default to protecting the po quantity, and figure on a partial case if necessary to do so.
		$bias:="qty"
	End if 
	
Else   //testing
	$qty:=24000
	$packAt:=999
	$bias:="odd"
End if 

If ($packAt>0)  //no div/0
	
	If (($qty%$packAt)>0)  //Modulo, odd lot because there is a remainder
		
		Case of 
			: (($bias="qty"))  //send enough cases to cover qty w/o being short
				$cases:=Int:C8(($qty\$packAt)+1)
				
			: ($bias="case")  //bias = case, don't send a partial case
				$cases:=Int:C8($qty\$packAt)
				
			: ($bias="odd")  //bias = odd, just
				$cases:=Round:C94(($qty/$packAt); 2)
				
			Else   //default to qty bias
				$cases:=Int:C8(($qty\$packAt)+1)
		End case 
		
		
	Else   //even lot
		$cases:=Round:C94(($qty/$packAt); 0)
	End if 
	
Else 
	$cases:=0  //err condition, don't want the INF
End if 

$0:=$cases

