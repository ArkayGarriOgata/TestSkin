//%attributes = {}
// Method: util_DateNotWeekend(date to test)->date after weekend or the date to test
// ----------------------------------------------------
// User name (OS): Mel Bohince : 06/18/20, 14:32:50
// ----------------------------------------------------
// Description
// so things don't get scheduled on a sat or sunday
C_DATE:C307($date; $1; $0)
$date:=$1

C_LONGINT:C283($day_of_week)
$day_of_week:=Day number:C114($date)

Case of 
	: ($day_of_week=Saturday:K10:18)
		$date:=Add to date:C393($date; 0; 0; 2)
		
	: ($day_of_week=Sunday:K10:19)
		$date:=Add to date:C393($date; 0; 0; 1)
End case 

$0:=$date

