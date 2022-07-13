//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/19/13, 19:36:43
// ----------------------------------------------------
// Method: Util_GetLastDayOfMonth
// Description:
// Returns the last day of the month passed in.
// Ignores leap year, who cares!
// ----------------------------------------------------

C_LONGINT:C283($xlMonth; $1; $0)

$xlMonth:=$1

Case of 
	: ($xlMonth=1)
		$0:=31
	: ($xlMonth=2)
		$0:=28
	: ($xlMonth=3)
		$0:=31
	: ($xlMonth=4)
		$0:=30
	: ($xlMonth=5)
		$0:=31
	: ($xlMonth=6)
		$0:=30
	: ($xlMonth=7)
		$0:=31
	: ($xlMonth=8)
		$0:=31
	: ($xlMonth=9)
		$0:=30
	: ($xlMonth=10)
		$0:=31
	: ($xlMonth=11)
		$0:=30
	: ($xlMonth=12)
		$0:=31
End case 