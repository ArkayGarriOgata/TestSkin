//%attributes = {"publishedWeb":true}
//Procedure: sDateLimitor()  
//•120998  MLB  make function and backDateAllowance
//•120998  MLB Y2K Remediation 
// Modified by: Mel Bohince (12/9/20) chg warning text
C_POINTER:C301($1)  //the date field
C_LONGINT:C283($2; $0; $3)  //number of days in horizon

$0:=0
$backDateBy:=0

If (Count parameters:C259>=3)
	$backDateBy:=$3
End if 

Case of 
	: ($1-><(4D_Current_date-$backDateBy))
		BEEP:C151
		ALERT:C41("You may not enter a date before "+String:C10(4D_Current_date-$3; Internal date short special:K1:4))  // Modified by: Mel Bohince (12/9/20) chg warming
		// $1»:=4D_Current_date
		$0:=$1->-4D_Current_date
		
	: ($1->>(4D_Current_date+$2))
		BEEP:C151
		ALERT:C41("You may not enter a date after "+String:C10(4D_Current_date+$2; Internal date short special:K1:4))
		$1->:=!00-00-00!
		$0:=$1->-4D_Current_date
End case 