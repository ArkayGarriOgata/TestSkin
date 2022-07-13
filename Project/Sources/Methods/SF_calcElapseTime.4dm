//%attributes = {"publishedWeb":true}
//PM: SF_calcElapseTime(TimeStampBegin;duration) -> end
//@author mlb - 2/22/02  15:37
//accumulate time lost because WC isn't crewed

//$3=Dept

C_LONGINT:C283($1; $2; $0; $end; $numShifts; $HOUR; $timeStartInSeconds; $duration; $start)
C_TEXT:C284($3; $ttDept)

C_DATE:C307($date)

$HOUR:=3600
$end:=0
$start:=$1
$date:=TS2Date($start)
$duration:=$2

$ttDept:=$3  //v1.0.0-PJK (12/23/15) added 3rd parameter for Dept.
//*finish out the first day
$secondsRemaining:=SF_calcSecondsRemaining($start; $ttDept)  //v1.0.0-PJK (12/23/15)

If ($duration<=$secondsRemaining)  //*finishes today
	$end:=$start+$duration
	
Else   //*if necessary, keep extending out
	$duration:=$duration-$secondsRemaining  //*burn up todays
	While ($duration>0)  //still time to use
		$date:=$date+1
		$numShifts:=SF_GetNumOfShifts($date; $ttDept)  //v1.0.0-PJK (12/23/15) added second parameter
		If ($numShifts=3)
			$start:=TSTimeStamp($date; ?00:00:01?)
		Else 
			$start:=TSTimeStamp($date; ?08:00:01?)
		End if 
		$secondsRemaining:=SF_calcSecondsRemaining($start; $ttDept)  //v1.0.0-PJK (12/23/15)
		
		If ($duration<=$secondsRemaining)  //*finishes today
			$end:=$start+$duration
			//$end:=SF_calcEnding ($end)
			$duration:=0
		Else   //*if necessary, keep extending out
			$duration:=$duration-$secondsRemaining
		End if 
	End while 
	
End if 

$0:=$end