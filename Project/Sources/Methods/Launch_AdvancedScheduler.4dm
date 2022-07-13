//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 12/16/15, 13:36:39
// ----------------------------------------------------
// Method: Launch_AdvancedScheduler
// Description
// 
//
// Parameters
// ----------------------------------------------------
$ttProcessName:="Advanced Job Scheduler"
$xlPID:=Process number:C372($ttProcessName)
If ($xlPID=0)
	$xlPID:=New process:C317("Job_AdvancedScheduler"; <>lMidMemPart; "Advanced Job Scheduler")
	If (False:C215)
		Job_AdvancedScheduler
	End if 
Else 
	SHOW PROCESS:C325($xlPID)
	BRING TO FRONT:C326($xlPID)
	POST OUTSIDE CALL:C329($xlPID)
End if 
