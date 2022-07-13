//%attributes = {}

// Method: util_DateOfNext3Days ( )  -> date
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/03/14, 13:29:17
// ----------------------------------------------------
// Description
// find the date that will include the next 3 days excluding weekend
//
// ----------------------------------------------------

C_LONGINT:C283($day_of_week)
C_DATE:C307($fence; $now; $0)
$fence:=!00-00-00!  //this better change when rtn'g
$now:=4D_Current_date
//$now:=!3/4/14!  //for testing weekend skip
$day_of_week:=Day number:C114($now)
//show 3 days excluding weekend
Case of 
	: ($day_of_week=Thursday:K10:16)
		$fence:=Add to date:C393($now; 0; 0; 4)
	: ($day_of_week=Friday:K10:17)
		$fence:=Add to date:C393($now; 0; 0; 4)
	: ($day_of_week=Saturday:K10:18)
		$fence:=Add to date:C393($now; 0; 0; 4)
	: ($day_of_week=Sunday:K10:19)
		$fence:=Add to date:C393($now; 0; 0; 3)
	Else 
		$fence:=Add to date:C393($now; 0; 0; 2)
End case 

$0:=$fence
