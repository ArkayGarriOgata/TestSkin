//%attributes = {}
// -------
// Method: Que_Scheduler( ) ->
// By: Mel Bohince @ 06/08/17, 09:41:29
// Description
// non blocking scheduler, delagate to Que_Worker
//see also Que_AddToQueue and Que_Worker, and Que_test
// ----------------------------------------------------
C_LONGINT:C283($interval; $event; $now; $pid)

If (Count parameters:C259=0)  //init
	C_BOOLEAN:C305(<>ScheduleReady)
	<>ScheduleReady:=False:C215
	//If (Semaphore("$que_in_use"))
	ARRAY LONGINT:C221(<>aScheduled; 0)  //the time
	ARRAY TEXT:C222(<>aScheduledUUID; 0)  // the identity
	ARRAY TEXT:C222(<>aScheduledCallback; 0)  //the method to run
	ARRAY TEXT:C222(<>aScheduledContext; 0)  //execute on client or server
	ARRAY TEXT:C222(<>aScheduledParams; 0)  //if params, deliminated by ;
	//Else 
	//ALERT("Problem starting Que_Scheduler")
	//ABORT
	//End if 
	
	//CLEAR SEMAPHORE("$que_in_use")
	<>ScheduleReady:=True:C214
	$interval:=60*10  //10 seconds
	
	zwStatusMsg("Que_Scheduler"; "Started...")
	utl_Logfile("que_scheduler.log"; "Started...")
	
	Repeat 
		//If (Not(Semaphore("$que_in_use";300)))
		//utl_Logfile ("que_scheduler.log";"Running...")
		
		Que_Display("sorted")
		$now:=TSTimeStamp
		
		For ($event; 1; Size of array:C274(<>aScheduled))
			
			If (<>aScheduled{$event}<=$now) & (<>aScheduled{$event}>0)  //run it
				If (<>aScheduledCallback{$event}#"TEST")
					utl_Logfile("que_scheduler.log"; <>aScheduledCallback{$event}+" Launching")
					$pid:=New process:C317("Que_Worker"; <>lMinMemPart; "Que_Worker_"+<>aScheduledCallback{$event}; <>aScheduledUUID{$event})
				End if 
				
			Else 
				utl_Logfile("que_scheduler.log"; <>aScheduledCallback{$event}+" Not yet")
			End if 
			
			If (<>aScheduled{$event}>$now)  //into the future, bail
				$event:=$event+Size of array:C274(<>aScheduled)
			End if 
			
		End for 
		
		
		//clear the zeros
		SORT ARRAY:C229(<>aScheduled; <>aScheduledCallback; <>aScheduledUUID; <>aScheduledContext; <>aScheduledParams; <)
		$event:=Find in array:C230(<>aScheduled; 0)
		If ($event>-1)
			$keep:=$event-1
			ARRAY LONGINT:C221(<>aScheduled; $keep)  //the time
			ARRAY TEXT:C222(<>aScheduledUUID; $keep)  // the identity
			ARRAY TEXT:C222(<>aScheduledCallback; $keep)  //the method to run
			ARRAY TEXT:C222(<>aScheduledContext; $keep)  //execute on client or server
			ARRAY TEXT:C222(<>aScheduledParams; $keep)  //if params, deliminated by ;
		End if 
		
		//IDLE
		//End if   //semaphore
		
		//CLEAR SEMAPHORE("$que_in_use")
		
		Que_Display("sorted")
		
		utl_Logfile("que_scheduler.log"; "Waiting...")
		DELAY PROCESS:C323(Current process:C322; $interval)
		//BEEP
	Until (Not:C34(<>Shuttle_Publish_On)) | (<>fQuit4D)
	//cleanup
	<>ScheduleReady:=False:C215
	<>pid_Shuttle_Publish:=0
	ARRAY LONGINT:C221(<>aScheduled; 0)  //the time
	ARRAY TEXT:C222(<>aScheduledUUID; 0)  // the identity
	ARRAY TEXT:C222(<>aScheduledCallback; 0)  //the method to run
	ARRAY TEXT:C222(<>aScheduledContext; 0)  //execute on client or server
	ARRAY TEXT:C222(<>aScheduledParams; 0)  //if params, deliminated by ;
	
	utl_Logfile("que_scheduler.log"; "Stopped")
End if 