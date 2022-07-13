//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: GanttCal_LoadTasks - Created `v1.0.0-PJK (12/22/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284(ttDept; $ttEnd; $ttEventName; $ttIntervalEnd; $ttIntervalStart; $ttResult; $ttStart; $ttTitle; $ttType)
C_DATE:C307($dDate; $dFirst; $dLast)
C_TIME:C306($hEndTime; $hStartTime)

$pCal:=->eaCal  //v5.3.5-CYH (12/2/15) added



WA EXECUTE JAVASCRIPT FUNCTION:C1043($pCal->; "getCalDetail"; $ttResult)
// agendaWeek;
// Nov 29 — Dec 5, 2015;
// 2015-11-29;
// 2015-12-06;
// 2015-11-29;
// 2015-12-06
$ttType:=GetNextField(->$ttResult; ";")
$ttTitle:=GetNextField(->$ttResult; ";")
$dFirst:=GanttCal_StringToDate(GetNextField(->$ttResult; ";"); ->$hStartTime)
$dLast:=GanttCal_StringToDate(GetNextField(->$ttResult; ";"); ->$hEndTime)
$ttIntervalStart:=GetNextField(->$ttResult; ";")
$ttIntervalEnd:=GetNextField(->$ttResult; ";")

WA EXECUTE JAVASCRIPT FUNCTION:C1043($pCal->; "clearCalEvents"; $ttResult)  //v5.3.5-CYH (12/2/15) added


ARRAY DATE:C224($sdDates; 0)
ARRAY TEXT:C222($sttLabels; 0)
GetShopSchedules(ttDept; $dFirst; $dLast; ->$sdDates; ->$sttLabels)

For ($i; 1; Size of array:C274($sdDates))
	$dDate:=$sdDates{$i}
	$xlYear:=Year of:C25($dDate)
	$xlMonth:=Month of:C24($dDate)
	$xlDay:=Day of:C23($dDate)
	
	$xlTaskSN:=Num:C11(String:C10($xlYear; "0000")+String:C10($xlMonth; "00")+String:C10($xlDay; "00"))
	$ttEventName:=$sttLabels{$i}
	$ttStart:=GanttCal_DateToString($dDate; ?00:00:00?)
	$ttEnd:=GanttCal_DateToString($dDate; ?00:00:00?)
	
	
	$fAllDay:=True:C214
	WA EXECUTE JAVASCRIPT FUNCTION:C1043($pCal->; "addCalEvent"; $ttResult; $ttEventName; $ttStart; $ttEnd; $fAllDay; $xlTaskSN)  //v5.3.5-CYH (12/2/15) added $ttEventName
End for 

