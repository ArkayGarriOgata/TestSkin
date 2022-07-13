//%attributes = {"publishedWeb":true}
// Method: PS_Gantt () -> 
// ----------------------------------------------------
//JML_PressScheduleGantt 12/13/01 Systems G4
//
//PM: JML_showGantt() -> 
//@author mlb - 11/21/01  14:03
//Procedure: JS_ShowGantt()  011498  MLB
//scritp for the button
//If (User in group(Current user;"RoleOperations"))
//READ WRITE([PressSchedule])
//End if 






//v1.0.0-PJK (12/21/15) completely rewrote
// Assumes selection of JobSchedules, lets revise it to pass in the Job Form ID, like 865543.06
C_TEXT:C284($1)


QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=($1+"@"))  //v1.0.0-PJK (12/22/15) moved to inside this method



C_PICTURE:C286(vStyle)
C_LONGINT:C283(eArea)
ARRAY TEXT:C222(aJobSeq; 0)
ARRAY TEXT:C222(aCPN; 0)
ARRAY TEXT:C222(aCustName; 0)
ARRAY TEXT:C222(aWC; 0)
ARRAY TEXT:C222(aState; 0)
ARRAY TEXT:C222(aInfo; 0)
ARRAY DATE:C224(aDate; 0)
ARRAY LONGINT:C221(aRecNo; 0)
ARRAY LONGINT:C221(aLi; 0)
ARRAY LONGINT:C221(aDur; 0)
ARRAY LONGINT:C221(aTime; 0)
ARRAY TEXT:C222(aString20; 0)
ARRAY TEXT:C222(aString23; 0)  //•102197  MLB 
ARRAY INTEGER:C220(aSequence; 0)
ARRAY LONGINT:C221(ats_Start; 0)
ARRAY LONGINT:C221(ats_End; 0)
ARRAY TEXT:C222(aCC; 0)
SELECTION TO ARRAY:C260([ProductionSchedules:110]; aRecNo; [ProductionSchedules:110]Priority:3; aLi; [ProductionSchedules:110]JobSequence:8; aJobSeq; [ProductionSchedules:110]Line:10; aCPN; [ProductionSchedules:110]Name:2; aWC; [ProductionSchedules:110]StartDate:4; aDate; [ProductionSchedules:110]StartTime:5; aTime; [ProductionSchedules:110]DurationSeconds:9; aDur; [ProductionSchedules:110]Customer:11; aCustName; [ProductionSchedules:110]Info:13; aInfo; [ProductionSchedules:110]EndDate:6; $aEndDate; [ProductionSchedules:110]EndTime:7; $aEndTime; [ProductionSchedules:110]CostCenter:1; aCC)

$numItems:=Size of array:C274(aJobSeq)
If ($numItems>0)
	ARRAY LONGINT:C221(ats_Start; $numItems)
	ARRAY LONGINT:C221(ats_End; $numItems)
	For ($i; 1; $numItems)
		$time:=Time:C179(Time string:C180(aTime{$i}))
		$startSeconds:=TSTimeStamp(aDate{$i}; $time)
		$endSeconds:=TSTimeStamp($aEndDate{$i}; $aEndTime{$i})
		$duration:=$endSeconds-$startSeconds
		aDur{$i}:=$duration  //Time(Time string($duration))*1
		ats_Start{$i}:=$startSeconds
		ats_End{$i}:=$endSeconds
	End for 
	
	SORT ARRAY:C229(ats_Start; aDur; aJobSeq; aWC; aDate; aTime; $aEndDate; $aEndTime; aCC; aDur; aLi; ats_End; >)
	utl_LogIt("init")
	$sp:="  "
	utl_LogIt("JobSequence "+$sp+"C/C"+$sp+"PRI"+$sp+"Starting       "+$sp+"Ending"; 0)
	$process:=0
	For ($i; 1; $numItems)
		$process:=$process+(ats_End{$i}-ats_Start{$i})
		utl_LogIt(aJobSeq{$i}+$sp+aCC{$i}+$sp+String:C10(aLi{$i}; "000")+$sp+Substring:C12(String:C10(aDate{$i}; Internal date short:K1:7); 1; 5)+$sp+Time string:C180(aTime{$i})+$sp+Substring:C12(String:C10($aEndDate{$i}; Internal date short:K1:7); 1; 5)+$sp+Time string:C180($aEndTime{$i})+$sp+aWC{$i}; 0)
	End for 
	$start:=ats_Start{1}
	$end:=ats_End{$numItems}
	$elapse:=$end-$start
	$que:=$elapse-$process
	utl_LogIt("-----"; 0)
	utl_LogIt("Thru-put: "+String:C10(Round:C94($process/$elapse*100; 0))+" %"; 0)
	utl_LogIt("Elapse: "+Time string:C180($elapse); 0)
	utl_LogIt("Process: "+Time string:C180($process); 0)
	utl_LogIt("Queue: "+Time string:C180($que); 0)
	
	//v1.0.0-PJK (12/22/15)  replace with custom dialog   utl_LogIt ("show")
	
	t1:=tCalculationLog  //v1.0.0-PJK (12/22/15)
	$xlWin:=Open form window:C675("AdvancedSchedulerSelect")  //v1.0.0-PJK (12/22/15)
	DIALOG:C40("AdvancedSchedulerSelect")  //v1.0.0-PJK (12/22/15)
	CLOSE WINDOW:C154  //v1.0.0-PJK (12/22/15)
	
	
	utl_LogIt("init")
	
Else 
	BEEP:C151
	ALERT:C41("Not Scheduled")
End if 

ARRAY TEXT:C222(aJobSeq; 0)
ARRAY TEXT:C222(aCPN; 0)
ARRAY TEXT:C222(aCustName; 0)
ARRAY TEXT:C222(aWC; 0)
ARRAY TEXT:C222(aState; 0)
ARRAY TEXT:C222(aInfo; 0)
ARRAY LONGINT:C221(aLi; 0)
ARRAY DATE:C224(aDate; 0)
ARRAY LONGINT:C221(aRecNo; 0)
ARRAY LONGINT:C221(aDur; 0)
ARRAY LONGINT:C221(aTime; 0)
ARRAY LONGINT:C221(ats_Start; 0)
ARRAY TEXT:C222(aCC; 0)



