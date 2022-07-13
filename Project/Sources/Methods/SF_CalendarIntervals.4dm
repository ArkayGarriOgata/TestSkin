//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 02/22/20, 19:17:54
// ----------------------------------------------------
// Method: SF_CalendarIntervals (dept)
// Description
//build a years worth of shopcalendar intervals for a dept to schedule against

//see also SF_ConvertSecondsToIntervals
C_TEXT:C284($dept; $1)
If (Count parameters:C259>0)
	$dept:=$1
Else 
	$dept:="420"
End if 

C_OBJECT:C1216($shopCalMonths; $month; $shopYear; $shopCalendar; $shopCalMonthsThisYear; $shopCalMonthsNextYear)
C_LONGINT:C283($schdHorizon)
C_BOOLEAN:C305($doNextYear)
//TODO make a decision whether to save the calendar and whether to fix the intervals
//TODO make a dialog for the next two questions unless we can standardize
$schdHorizon:=3  //Num(Request("Months in horizon?";"3";"Continue";"Cancel"))//number of months to plan for

$doNextYear:=(Month of:C24(Current date:C33)>(12-$schdHorizon))

$specifiedIntervalsPerHour:=4  //Num(Request("Intervals per hour?";"4";"Continue";"Cancel"))


C_COLLECTION:C1488(deptCalendar)
deptCalendar:=New collection:C1472

zwStatusMsg("SHOP CAL"; "Getting settings... ")
C_LONGINT:C283($intervalsPerHour; $pid)
$intervalsPerHour:=SF_CalendarIntervalsSettings("set"; $specifiedIntervalsPerHour)  //recommend 6 for 10 minute intervals, this is used in SF_CalendarIntervalsDoMonth and also used in a trigger on the prodschd table SF_ConvertSecondsToIntervals so make sure both
$pid:=Execute on server:C373("SF_CalendarIntervalsSettings"; 0; "SF_Interval"; "set"; $intervalsPerHour)  //keep the server in sync for use of trigger

If (True:C214)  //apply the trigger
	READ WRITE:C146([ProductionSchedules:110])
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=$dept)
	APPLY TO SELECTION:C70([ProductionSchedules:110]; [ProductionSchedules:110]DurationTemp:17:=[ProductionSchedules:110]DurationTemp:17*1)  //run the trigger
	REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
End if 

$startTime:=Current time:C178
zwStatusMsg("SHOP CAL"; "Looking for a saved calendar... ")
$shopCalendar:=ds:C1482.ProductionSchedules_Shop_Cal.query("Dept = :1 and psMonth = :2"; $dept; 1).first()  // see if Jan has the calender collection saved

If ($shopCalendar.IntervalCalendar=Null:C1517) | (True:C214)  //regenerate
	
	zwStatusMsg("SHOP CAL"; "Need to build calendar... ")
	//first get the entire year of months and sort it
	zwStatusMsg("SHOP CAL"; "Loading all shifts... ")
	$shopCalMonths:=ds:C1482.ProductionSchedules_Shop_Cal.query("Dept = :1"; $dept).orderBy("psMonth")  //all the months order jan to dec
	$thisMth:=Month of:C24(Current date:C33)
	//split the year into current and next year's months, can't do sequencially otherwise
	zwStatusMsg("SHOP CAL"; "Splitting of this years shifts... ")
	$shopCalMonthsThisYear:=$shopCalMonths.slice($thisMth-1; 12).orderBy("psMonth")  //grab from this month to the end of the year
	
	zwStatusMsg("SHOP CAL"; "from next years shifts... ")
	$shopCalMonthsNextYear:=$shopCalMonths.slice(0; $thisMth-1).orderBy("psMonth")  //get the months that will be next year
	
	//rerun the same loop to finish out the current year and then to start the next year
	//THIS YEAR:
	$monthInHorizon:=1
	For each ($month; $shopCalMonthsThisYear)
		If ($monthInHorizon<=$schdHorizon)  //don't build the entire year if unnecessary
			zwStatusMsg("SHOP CAL"; "building this year "+String:C10($month.psMonth))
			SF_CalendarIntervalsDoMonth($month; ->deptCalendar)  //do a month of intervals for this year
			$monthInHorizon:=$monthInHorizon+1
		End if 
	End for each   //month in the year specified
	
	//NEXT YEAR:
	If ($doNextYear)
		For each ($month; $shopCalMonthsNextYear)
			If ($monthInHorizon<=$schdHorizon)  //don't build the entire year if unnecessary
				zwStatusMsg("SHOP CAL"; "building next year "+String:C10($month.psMonth))
				//do a month for next year
				$month.psYear:=1  //bump the year up by one
				SF_CalendarIntervalsDoMonth($month; ->deptCalendar)
				$monthInHorizon:=$monthInHorizon+1
			End if 
		End for each   //month in the year specified
	End if 
	
	zwStatusMsg("SHOP CAL"; "Calendar is ready. ")
	//save the collection somewhere
	If (True:C214)
		$shopYear:=New object:C1471
		$shopYear.allIntervals:=deptCalendar
		$month:=ds:C1482.ProductionSchedules_Shop_Cal.query("Dept = :1 and psMonth = :2"; $dept; 1).first()
		If ($month#Null:C1517)
			$month.IntervalCalendar:=$shopYear
			$month.save()
		End if 
	End if 
	
Else   //use a saved copy
	deptCalendar:=$shopCalendar.IntervalCalendar.allIntervals
End if   //regen

//ALERT(String(Current time-$startTime))
//CONFIRM("extend "+$dept+"?";"Extend";"Done")
//If (ok=1)
SF_CalendarIntervalsExtend($dept; ->deptCalendar)
//End if 

//CONFIRM("view calendar for "+$dept+"?";"View";"Done")
//If (ok=1)
C_OBJECT:C1216($form_o)
$form_o:=New object:C1471
$form_o.intervals:=deptCalendar
C_TEXT:C284($useThisWindowTitle)
$useThisWindowTitle:="Dept "+$dept+" @ "+TS2iso
// Modified by: Mel Bohince (3/9/20) open to the rite of sched window
C_LONGINT:C283($width; $height; $numPages)  // these are set on the by the button: rightWin;topWin;rightWin;topWin)
C_BOOLEAN:C305($fixedWidth; $fixedHeight)
C_TEXT:C284($formTitle)
FORM GET PROPERTIES:C674([ProductionSchedules_Shop_Cal:116]; "DisplayIntervals"; $width; $height; $numPages; $fixedWidth; $fixedHeight; $formTitle)
$winRef:=Open window:C153(rightWin; topWin; rightWin+$width; topWin+$height; Plain form window:K39:10; $useThisWindowTitle; "wCloseCancel")
//$winRef:=OpenFormWindow (->[ProductionSchedules_Shop_Cal];"DisplayIntervals";->$useThisWindowTitle;$useThisWindowTitle)

If (Count parameters:C259>0)
	DIALOG:C40([ProductionSchedules_Shop_Cal:116]; "DisplayIntervals"; $form_o; *)
Else 
	DIALOG:C40([ProductionSchedules_Shop_Cal:116]; "DisplayIntervals"; $form_o)  //asteric makes dialog go away
End if 
//End if 

//end if//intervals/hr specified
//end if//months specified

