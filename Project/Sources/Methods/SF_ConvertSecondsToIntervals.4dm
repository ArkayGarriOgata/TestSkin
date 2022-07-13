//%attributes = {}
// _______
// Method: SF_ConvertSecondsToIntervals   ( duration in seconds ) -> duration in intervals
// By: Mel Bohince @ 02/24/20, 12:43:19
// Description
// called from trigger_ProductionSchedules to convert the duration seconds into more managable time blocks
// ----------------------------------------------------

C_LONGINT:C283($intervalsPerHour; $durationInSeconds; $1; $0; $secondsPerHour; $secondsPerInterval)
C_REAL:C285($durationInIntervals)

$intervalsPerHour:=SF_CalendarIntervalsSettings("get")

$secondsPerHour:=3600
$secondsPerInterval:=$secondsPerHour/$intervalsPerHour

If (Count parameters:C259=1)
	$durationInSeconds:=$1
Else   //testing
	$durationInSeconds:=4000
End if 

//alway use at least one interval
If ($durationInSeconds<$secondsPerInterval)
	$durationInSeconds:=$secondsPerInterval
End if 

//rely on the round function to get to the nearest interval
$durationInIntervals:=Round:C94(($durationInSeconds/$secondsPerInterval); 0)  //be discrete

$0:=Int:C8($durationInIntervals)  //cast to int

//$minutesPerInterval:=60/$intervalsPerHour
//$hoursPerShift:=8
//$intervalsPerShift:=$intervalsPerHour*$hoursPerShift