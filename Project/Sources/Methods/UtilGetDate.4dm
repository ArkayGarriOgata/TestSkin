//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/13/12, 11:33:47
// ----------------------------------------------------
// Method: UtilGetDate(date;what{;->endOfMth)->date
// Description:
// Returns a date.
// If $3 exists, it's filled with a ending date.
// ----------------------------------------------------

C_DATE:C307($dDate; $1; $0)
C_TEXT:C284($tWhat; $2)
C_LONGINT:C283($xlDay; $xlMonth)
C_POINTER:C301($3; $pEndDate)

$dDate:=$1
$tWhat:=$2
If (Count parameters:C259=3)  // Added by: Mark Zinke (4/1/13)
	$pEndDate:=$3
End if 

Case of 
	: ($tWhat="Yesterday")
		$0:=$dDate-1
		If (Count parameters:C259=3)  // Added by: Mark Zinke (4/1/13)
			$pEndDate->:=$0
		End if 
		
	: ($tWhat="ThisWeek")
		$xlDay:=Day number:C114($dDate)
		$0:=$dDate-$xlDay+1
		If (Count parameters:C259=3)  // Added by: Mark Zinke (4/1/13)
			$pEndDate->:=Add to date:C393($0; 0; 0; 6)
		End if 
		
	: ($tWhat="LastWeek")
		$xlDay:=Day number:C114($dDate)
		$0:=$dDate-$xlDay-6
		If (Count parameters:C259=3)  // Added by: Mark Zinke (4/1/13)
			$pEndDate->:=Add to date:C393($0; 0; 0; 6)
		End if 
		
	: ($tWhat="ThisMonth")
		$xlMonth:=Month of:C24($dDate)
		$xlYear:=Year of:C25($dDate)
		$0:=Date:C102(String:C10($xlMonth)+"/01/"+String:C10($xlYear))
		If (Count parameters:C259=3)  // Added by: Mark Zinke (4/1/13)
			$pEndDate->:=Add to date:C393($0; 0; 1; -1)
		End if 
		
End case 