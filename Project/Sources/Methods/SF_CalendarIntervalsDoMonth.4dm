//%attributes = {}
// _______
// Method: SF_CalendarIntervalsDoMonth   ( $monthObj;->deptCalendarCollection) ->
// By: Mel Bohince @ 02/25/20, 14:32:14
// Description
// refactored some inline code
//goal is to build a month worth of time intervals and add them to the years collection of intervals
//THIS BUILDS ONTO THE deptCalendar COLLECTION CREATED IN THE CALLING METHOD passed in by reference!!!!
//see also SF_ConvertSecondsToIntervals
// ----------------------------------------------------
C_OBJECT:C1216($month; $1; $intervalObj)
$month:=$1
C_POINTER:C301($2)
$deptCalendar:=$2
C_BOOLEAN:C305($avail)

C_LONGINT:C283($hoursPerShift; $intervalsPerShift; $intervalsPerHour; $now)
$now:=TSTimeStamp
$intervalsPerHour:=SF_CalendarIntervalsSettings("get")
$minutesPerInterval:=60/$intervalsPerHour
$hoursPerShift:=8
$intervalsPerShift:=$intervalsPerHour*$hoursPerShift

$yearOf:=String:C10(Year of:C25(Current date:C33)+$month.psYear)  //psYear is normally 0, but changing this to 1 or more will project into the following year(s) to be able to wrap around December
$monthOf:=String:C10($month.psMonth)
$date:=Date:C102($monthOf+"/1/"+$yearOf)  //begin on the first of the month
$day:=Day of:C23($date)  //just in case this changes to a mid-month start, otherwise grabbing all the shifts
$shifts:=Substring:C12($month.Shifts; $day)
//$thePast:=Current date-1
For ($dayOfMonth; 1; Length:C16($shifts))  //looping thru the days of the month
	//If ($date>=$thePast)
	//need to treat mondays and fridays special, make it start sunday nite
	//TODO TODO  UNTESTED IF OT SET ON THE WEEKEND
	$weekday:=Day number:C114(Date:C102($monthOf+"/"+String:C10($dayOfMonth)+"/"+$yearOf))
	$numberOfShifts:=Num:C11(Substring:C12($shifts; $dayOfMonth; 1))
	
	Case of 
		: ($weekday=2) & ($numberOfShifts=3)  //3 shifts on monday means they started Sunday night at 10pm
			$yesterday:=$date-1
			$timeInSeconds:=TSTimeStamp($yesterday; ?22:00:00?)  //start of third shift starts sunday nite at 10pm and ends friday morning at 6ams
			$numberOfShifts:=4
			
		: ($weekday=6) & ($numberOfShifts=3)  //friday just works until 10
			$timeInSeconds:=TSTimeStamp($date; ?06:00:00?)  //start of first shift on a weekday
			$numberOfShifts:=2  //third shift started on sunday
			
		Else 
			$timeInSeconds:=TSTimeStamp($date; ?06:00:00?)  //start of first shift on a weekday
	End case 
	
	For ($shift; 1; $numberOfShifts)  //$numberOfShifts)
		
		For ($i; 1; $intervalsPerShift)
			//If ($timeInSeconds>=$now)
			$avail:=True:C214
			//Else   //in the past
			//$avail:=False
			//End if 
			$intervalObj:=New object:C1471("available"; $avail; "startTime"; TS2iso($timeInSeconds); "timeStampSeconds"; $timeInSeconds; "task"; ""; "interval"; 0)
			$deptCalendar->push($intervalObj)
			$timeInSeconds:=$timeInSeconds+(60*$minutesPerInterval)
		End for   //shift
	End for   //number of shifts
	
	//end if//not in the past
	$date:=$date+1
End for   //workday