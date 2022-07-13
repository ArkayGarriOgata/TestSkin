//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 03/11/11, 16:12:49
// ----------------------------------------------------
// Method: pattern_Listener_descrete
// ----------------------------------------------------

C_TIME:C306($run_time)

$wait_until_complete:=1  //option to run sync=1 or async=0
//run at specified time
$run_time:=?16:40:00?
$when:=TSTimeStamp(Current date:C33; $run_time)
app_event_scheduler("set-time"; Current process:C322; $when; $wait_until_complete)  //register with the event loop

//wait for first call
PAUSE PROCESS:C319(Current process:C322)

While (Not:C34(<>fQuit4D)) & (Not:C34(<>kill_event_scheduler) & ($when>0))
	//||||||||||||||||||||||||||||||||||||||||||`your code here
	
	BEEP:C151  //do it
	zwStatusMsg("Run at"; TS_ISO_String_TimeStamp)
	
	If ($wait_until_complete=1)  //simulate processing
		DELAY PROCESS:C323(Current process:C322; 60*30)
	End if 
	//||||||||||||||||||||||||||||||||||||||||||`your code here
	
	If (True:C214)  //reset the next when if not a single run
		//set when to 0 is you want to clear from scheduler
		$when:=TSTimeStamp(Current date:C33+1; $run_time)
		app_event_scheduler("set-time"; Current process:C322; $when; $wait_until_complete)  //reset in cases where "do it" takes awhile
	End if 
	
	PAUSE PROCESS:C319(Current process:C322)
End while 