//%attributes = {"publishedWeb":true}
//PM: PS_PressSchedule() -> 
//@author mlb - 12/4/01  14:29
//If (User in group(Current user;"RoleOperations"))
// Modified by: Mel Bohince (6/7/17) If (User in group(Current user;"SchedulingAssistant"))default showing completed seqs
// Modified by: MelvinBohince (1/21/22) remove call to init the JML_cache

C_TEXT:C284(tText; otpct)
C_BOOLEAN:C305($canMakeChanges)
C_TEXT:C284($1)
C_LONGINT:C283($winRef; $xlWhat; bShowCompleted)
C_REAL:C285(pressBackLog)
C_PICTURE:C286(pict1; pict2; pict3; pict4; pict5; pict6; pict7)
C_POINTER:C301($thisPress; $thisWindow)
C_BOOLEAN:C305($fGO)  //v1.0.0-PJK (12/7/15)
C_TEXT:C284(ttGotoOperationID; $2)  //v1.0.0-PJK (12/17/15)

ttGotoOperationID:=""  //v1.0.0-PJK (12/17/15)
If (Count parameters:C259>1)  //v1.0.0-PJK (12/17/15)
	ttGotoOperationID:=$2  //v1.0.0-PJK (12/17/15)
End if   //v1.0.0-PJK (12/17/15)

REDUCE SELECTION:C351([Cost_Centers:27]; 0)
REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)

MESSAGES OFF:C175

READ ONLY:C145([ProductionSchedules:110])
READ ONLY:C145([Job_Forms_Master_Schedule:67])
READ ONLY:C145([Cost_Centers:27])
READ ONLY:C145([Customers:16])  // Modified by: Mel Bohince (4/10/17) 
// Added by: Mel Bohince (1/28/20):
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Jobs:15])

$canMakeChanges:=User in group:C338(Current user:C182; "RoleOperations")

While (Semaphore:C143("$JMLcacheInit"))
	zwStatusMsg("Please Wait..."; "Caching Job Master Log info. It won't be long...")
	DELAY PROCESS:C323(Current process:C322; 10)
End while 
CLEAR SEMAPHORE:C144("$JMLcacheInit")

otpct:=""  //"Last week overall On-time delivery was: "+OnTime_getRecent 
sCriterion1:=$1
bNext3Weeks:=0
bNeedPlated:=0
If (User in group:C338(Current user:C182; "SchedulingAssistant"))  //default showing completed seqs
	PS_ShowCompleted("show")
Else 
	PS_ShowCompleted("hide")
End if 

SET MENU BAR:C67("Scheduling_full")
windowTitle:=sCriterion1+" Schedule"
$winRef:=OpenFormWindow(->[zz_control:1]; "PressSchedule"; ->windowTitle; windowTitle)
$winRef:=PS_pid_mgr("setwin"; sCriterion1; $winRef)

FORM SET INPUT:C55([zz_control:1]; "PressSchedule")
FORM SET OUTPUT:C54([zz_control:1]; "PressSchedulePrint")
util_PAGE_SETUP(->[zz_control:1]; "PressSchedulePrint")
ADD RECORD:C56([zz_control:1]; *)
//don't save

CLOSE WINDOW:C154($winRef)

$pid:=PS_pid_mgr("setpid"; sCriterion1; 0)
$winRef:=PS_pid_mgr("setwin"; sCriterion1; 0)
