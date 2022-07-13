//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: Adv_ScheduleToMachine - Created `v1.0.0-PJK (12/16/15)
//$1=MachineID to schedule to
//$2=Job Sequence ID
C_TEXT:C284($1; $2)
C_BOOLEAN:C305(fFromAdvScheduler; $0)
C_LONGINT:C283($xlPriority)
C_DATE:C307(dDate)
C_TIME:C306(hTime)

fFromAdvScheduler:=True:C214
sCriterion1:=$1
sCriterion9:=$2

Adv_SchedulePriorityDateTime(sCriterion1; ->$xlPriority; ->dDate; ->tTime)

If (dDate=!00-00-00!)
	dDate:=4D_Current_date
End if 
If (tTime=?00:00:00?)
	tTime:=4d_Current_time+?01:00:00?  // One hour from now
End if 
sCriterion5:=String:C10($xlPriority)

$winRef:=OpenSheetWindow(->[ProductionSchedules:110]; "NewJobSeq")  //;0;$x;$y-200)
DIALOG:C40([ProductionSchedules:110]; "NewJobSeq")
$0:=(OK=1)
CLOSE WINDOW:C154  //($winRef)
fFromAdvScheduler:=False:C215