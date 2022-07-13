//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: GanttCal_UpdateDates - Created `v1.0.0-PJK (12/22/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 


C_LONGINT:C283($xlTaskSN; $1)
C_TEXT:C284($2; $3)
C_DATE:C307($dStartDate; $dEndDate)
C_TIME:C306($hStartDate; $hEndTime)
$xlTaskSN:=$1
$dStartDate:=GanttCal_StringToDate($2; ->$hStartDate)
$dEndDate:=GanttCal_StringToDate($3; ->$hEndTime)

TRACE:C157
//UNLOAD RECORD([Tasks])
//$fPush:=PushTable(->[Tasks];"HoldGTTasks")
//QUERY([Tasks];[Tasks]SeqNum=$xlTaskSN)
//[Tasks]DateStarted:=$dStartDate
//[Tasks]TimeStarted:=$hStartDate
//[Tasks]DatePromised:=$dEndDate
//[Tasks]TimePromised:=$hEndTime
//SAVE RECORD([Tasks])
//PopTable(->[Tasks];"HoldGTTasks";$fPush)

//xlGanttSelectedID:=$xlTaskSN
//ttGanttSelectedPriority:=("Task"*Num(xlGanttSelectedID#0))  //v5.3.5-PJK (12/4/15) ONLY set to TASK if we have a valid SN

//fGTIsTask:=(ttGanttSelectedPriority#"Special")
//Gantt_TaskToDetailArea
//Gantt_ConfigureInfo
