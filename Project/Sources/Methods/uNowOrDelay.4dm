//%attributes = {"publishedWeb":true}
//(P) uNowOrDelay: asks user if process is to go now or be delayed
//works in conjunctionm with (P) uReportProcess to handle
//delaying processes
//122199 mlb postpone starting Rep[ort mgr until needed

C_BOOLEAN:C305($0)
C_LONGINT:C283(delayUntilTimestamp; $2)  //timestamp
C_DATE:C307(delayUntilDate)
C_TIME:C306(delayUntilTime)
C_TEXT:C284($1)

$title:=""
$pid:=Current process:C322

If (Count parameters:C259>=1)
	$title:=$1
	If (Count parameters:C259>=2)
		$pid:=$2
	End if 
End if 

NewWindow(270; 125; 6; 5; "Scheduler")  //open window cewntered on current
DIALOG:C40([zz_control:1]; "NowOrDelay")  //display dialog for user selection
CLOSE WINDOW:C154
If (OK=1)
	If (rDelayb1#1)
		util_Scheduler
		<>delayCanceled:=False:C215
		DELAY PROCESS:C323(Current process:C322; 30)
		util_Scheduler($pid; delayUntil)
		$delayWinRef:=NewWindow(450; 1; 2; -726; "SCHEDULED PROCESS "+uProcessName($pid)+" Delayed until "+TS2String(delayUntil); "wCloseCancel")
		
		PAUSE PROCESS:C319($pid)  //finally pause the process, report manager will restart
		zwStatusMsg("SCHEDULER"; "PROCESS "+uProcessName($pid)+" Executing.")
		CLOSE WINDOW:C154($delayWinRef)
		
		If (<>delayCanceled)  //killed in its sleep  
			$0:=False:C215
			zwStatusMsg("SCHEDULER"; "PROCESS "+uProcessName($pid)+" cancelled.")
			<>delayCanceled:=False:C215  //reset
			
		Else   //proceed
			$0:=True:C214
		End if 
		
	Else 
		$0:=True:C214  //run now    
	End if 
	
Else   //canceled dio
	$0:=False:C215
End if 