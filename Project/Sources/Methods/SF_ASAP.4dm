//%attributes = {"publishedWeb":true}
//PM: SF_ASAP(date) -> date
//@author mlb - 2/22/02  15:01
//return soonest date that has shifts
//$1=Date
//$2=Dept

C_DATE:C307($1; $0)
C_TEXT:C284($2; $ttDept)
C_LONGINT:C283($numShifts; $trys)

$date:=$1
$ttDept:=$2  //v1.0.0-PJK (12/23/15)
$trys:=0
$numShifts:=SF_GetNumOfShifts($date; $ttDept)  //v1.0.0-PJK (12/23/15) added second parameter

While ($numShifts=0) & ($trys<30)
	$date:=$date+1
	$trys:=$trys+1
	$numShifts:=SF_GetNumOfShifts($date; $ttDept)  //v1.0.0-PJK (12/23/15) added second parameter
End while 

$0:=$date