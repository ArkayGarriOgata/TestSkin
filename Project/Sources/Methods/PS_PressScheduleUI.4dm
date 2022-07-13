//%attributes = {"publishedWeb":true}
//PM: PS_PressScheduleUI() -> 
//@author mlb - 10/30/01  15:50
// • mel (2/2/04, 14:25:10)guard againt nil pointer 
PS_JustInTime  // Modified by: Mel Bohince (6/3/21) 

C_TEXT:C284($1)
C_LONGINT:C283($0; $pid)

If (Count parameters:C259=0)  //find the press number
	If (Substring:C12(Current user:C182; 1; 5)="Press")
		//PS_MakeReadyTimer (1)
		$press:=Substring:C12(Current user:C182; 6)
		
	Else 
		$press:="All"
	End if 
	
Else   //use the press number passed
	$press:=$1
End if 

$pid:=PS_pid_mgr("pid"; $press)
If ($pid>-1)
	If ($pid=0)
		$pid:=New process:C317("PS_PressSchedule"; <>lMidMemPart; $press+" Schedule"; $press)
		If (False:C215)
			PS_PressSchedule
		End if 
		
		$pid:=PS_pid_mgr("setpid"; $press; $pid)
	Else 
		SHOW PROCESS:C325($pid)
		BRING TO FRONT:C326($pid)
		WindowPositionMove([WindowSets:185]WindowTitle:3)  // Added by: Mark Zinke (1/10/13)
		POST OUTSIDE CALL:C329($pid)
	End if 
	
Else 
	BEEP:C151
End if 

$0:=$pid  // Added by: Mark Zinke (1/10/13)