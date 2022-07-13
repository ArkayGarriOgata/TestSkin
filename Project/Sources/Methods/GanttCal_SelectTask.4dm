//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: GanttCal_SelectTask - Created `v1.0.0-PJK (12/22/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($1; $xlTaskSN)
C_TEXT:C284($ttDate; $ttResult)
C_TEXT:C284($ttValue)
C_POINTER:C301($pCal)

$pCal:=->eaCal  //v5.3.5-CYH (12/2/15) added

$xlTaskSN:=$1
$ttDate:=String:C10($xlTaskSN)

$xlYear:=Substring:C12($ttDate; 1; 4)
$xlMonth:=Substring:C12($ttDate; 5; 2)
$xlDay:=Substring:C12($ttDate; 7; 2)
$dDate:=Date:C102(String:C10($xlMonth)+"/"+String:C10($xlDay)+"/"+String:C10($xlYear))
//alert(string($dDate))

READ WRITE:C146([ProductionSchedules_Shifts:180])
QUERY:C277([ProductionSchedules_Shifts:180]; [ProductionSchedules_Shifts:180]Dept:4=ttDept; *)
QUERY:C277([ProductionSchedules_Shifts:180];  & ; [ProductionSchedules_Shifts:180]ShiftDate:1=$dDate)
If (MULOADREC(->[ProductionSchedules_Shifts:180]; False:C215))
	$ttValue:=Request:C163("Enter Shift Value:"; [ProductionSchedules_Shifts:180]Value:5)
	If (OK=1)
		[ProductionSchedules_Shifts:180]Value:5:=$ttValue
		SAVE RECORD:C53([ProductionSchedules_Shifts:180])
		
		$ttEventName:=[ProductionSchedules_Shifts:180]Value:5
		WA EXECUTE JAVASCRIPT FUNCTION:C1043($pCal->; "updateCalEvent"; $ttResult; $xlTaskSN; $ttEventName)  //v5.3.5-CYH (12/2/15) added $ttEventName
		
	End if 
Else 
	ALERT:C41("That record is currently in use by another user or process and cannot be modified at this time.")
End if 





//AL_UnsetAllLines(->eaTaskList)
//xlGanttSelectedID:=$xlTaskSN
//ttGanttSelectedPriority:=("Task"*Num(xlGanttSelectedID#0))  //v5.3.5-PJK (12/4/15) ONLY set to TASK if we have a valid SN

//fGTIsTask:=(ttGanttSelectedPriority#"Special")
//Gantt_TaskToDetailArea
//Gantt_ConfigureInfo 
