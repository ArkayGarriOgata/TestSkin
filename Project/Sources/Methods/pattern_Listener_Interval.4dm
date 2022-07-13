//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 03/11/11, 16:11:59
// ----------------------------------------------------
// Method: pattern_Listener_Interval
// ----------------------------------------------------

$wait_until_complete:=1  //option to run sync=1 or async=0
//set interval
$interval_seconds:=20  //in seconds, 0 to delete
app_event_scheduler("register"; Current process:C322; $interval_seconds; $wait_until_complete)  //register with the event loop

//wait for first call
PAUSE PROCESS:C319(Current process:C322)

While (Not:C34(<>fQuit4D)) & (Not:C34(<>kill_event_scheduler) & ($interval_seconds>0))  //is not aborted or quitting
	//||||||||||||||||||||||||||||||||||||||||||`your code here
	
	BEEP:C151  //do it
	zwStatusMsg("Run"; TS_ISO_String_TimeStamp)
	
	If ($wait_until_complete=1)  //simulate processing
		DELAY PROCESS:C323(Current process:C322; 60*30)
	End if 
	//||||||||||||||||||||||||||||||||||||||||||`your code here
	
	If (False:C215)  //optionally reset the when interval or 0 to abort, if not it just repeats forever with same interval
		app_event_scheduler("register"; Current process:C322; $interval_seconds; $wait_until_complete)  //reset in cases where "do it" takes awhile
	End if 
	//wait for next call
	PAUSE PROCESS:C319(Current process:C322)
End while 