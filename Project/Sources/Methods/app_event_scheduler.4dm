//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 03/08/11, 16:18:57
// ----------------------------------------------------
// Method: app_event_scheduler
// Description
// see also pattern_Listener_Interval and pattern_Listener_descrete
// ----------------------------------------------------

Case of 
	: (Count parameters:C259=0)  //set up the event loop
		<>kill_event_scheduler:=False:C215
		ARRAY INTEGER:C220(<>pid_call_back; 0)
		ARRAY LONGINT:C221(<>pid_interval; 0)
		ARRAY LONGINT:C221(<>pid_event_time; 0)
		ARRAY INTEGER:C220(<>pid_wait_until_complete; 0)
		
		$loop_interval_ticks:=60*5  //5 seconds
		
		Repeat 
			If (Not:C34(Semaphore:C143("$Events_Running"; 60*5)))
				$now:=TSTimeStamp
				For ($event; 1; Size of array:C274(<>pid_call_back))
					If (<>pid_event_time{$event}<=$now) & (<>pid_event_time{$event}#0)
						RESUME PROCESS:C320(<>pid_call_back{$event})
						//
						If (<>pid_wait_until_complete{$event}=1)  //wait until pid is paused again
							Repeat 
								DELAY PROCESS:C323(Current process:C322; $loop_interval_ticks)
							Until (Process state:C330(<>pid_call_back{$event})=Paused:K13:6)
						End if 
						
						//set up for next running
						If (<>pid_interval{$event}>0)
							<>pid_event_time{$event}:=(TSTimeStamp+<>pid_interval{$event})
						Else   //single @time run
							<>pid_event_time{$event}:=0
						End if 
					End if 
					
				End for 
				
				CLEAR SEMAPHORE:C144("$Events_Running")
			End if 
			
			zwStatusMsg("Pausing"; TS_ISO_String_TimeStamp+" "+String:C10(Size of array:C274(<>pid_call_back))+" listeners")
			DELAY PROCESS:C323(Current process:C322; $loop_interval_ticks)
			
		Until (<>fQuit4D) | (<>kill_event_scheduler)
		
	: ($1="register")  //register with the event timer
		$pid:=Process number:C372("$Event Scheduler")
		If ($pid=0)
			$pid:=New process:C317("app_event_scheduler"; <>lMinMemPart; "$Event Scheduler"; *)
			DELAY PROCESS:C323(Current process:C322; 5)
		End if 
		
		$interval:=$3
		If (Not:C34(Semaphore:C143("$Events_Running"; 60*5)))  // Wait 5 seconds if the semaphore already exists
			$all_ready_registered:=Find in array:C230(<>pid_call_back; $2)
			If ($all_ready_registered=-1)
				If ($3>0)  //must have an interval
					APPEND TO ARRAY:C911(<>pid_call_back; $2)  //Current process of caller
					APPEND TO ARRAY:C911(<>pid_interval; $interval)  //$interval:=60*60*1
					APPEND TO ARRAY:C911(<>pid_event_time; (TSTimeStamp+$interval))
					APPEND TO ARRAY:C911(<>pid_wait_until_complete; $4)
				End if 
			Else 
				If ($3>0)
					<>pid_interval{$all_ready_registered}:=$3
					<>pid_event_time{$all_ready_registered}:=(TSTimeStamp+$3)
					<>pid_wait_until_complete{$all_ready_registered}:=$4
				Else 
					DELETE FROM ARRAY:C228(<>pid_call_back; $all_ready_registered; 1)
					DELETE FROM ARRAY:C228(<>pid_interval; $all_ready_registered; 1)
					DELETE FROM ARRAY:C228(<>pid_event_time; $all_ready_registered; 1)
					DELETE FROM ARRAY:C228(<>pid_wait_until_complete; $all_ready_registered; 1)
				End if 
			End if 
			CLEAR SEMAPHORE:C144("$Events_Running")  // Clear the semaphore
		End if 
		
	: ($1="set-time")  //register with the event timer for specific time
		$pid:=Process number:C372("$Event Scheduler")
		If ($pid=0)
			$pid:=New process:C317("app_event_scheduler"; <>lMinMemPart; "$Event Scheduler"; *)
			DELAY PROCESS:C323(Current process:C322; 5)
		End if 
		
		If (Not:C34(Semaphore:C143("$Events_Running"; 60*5)))  // Wait 5 seconds if the semaphore already exists
			$all_ready_registered:=Find in array:C230(<>pid_call_back; $2)
			If ($all_ready_registered=-1)
				If ($3>TSTimeStamp)  //must be in future
					APPEND TO ARRAY:C911(<>pid_call_back; $2)  //Current process of caller
					APPEND TO ARRAY:C911(<>pid_interval; 0)
					APPEND TO ARRAY:C911(<>pid_event_time; $3)
					APPEND TO ARRAY:C911(<>pid_wait_until_complete; $4)
				End if 
			Else 
				If ($3>0)
					<>pid_interval{$all_ready_registered}:=0
					<>pid_event_time{$all_ready_registered}:=$3
					<>pid_wait_until_complete{$all_ready_registered}:=$4
				Else 
					DELETE FROM ARRAY:C228(<>pid_call_back; $all_ready_registered; 1)
					DELETE FROM ARRAY:C228(<>pid_interval; $all_ready_registered; 1)
					DELETE FROM ARRAY:C228(<>pid_event_time; $all_ready_registered; 1)
					DELETE FROM ARRAY:C228(<>pid_wait_until_complete; $all_ready_registered; 1)
				End if 
			End if 
			CLEAR SEMAPHORE:C144("$Events_Running")  // Clear the semaphore
		End if 
		
	: ($1="kill")
		<>kill_event_scheduler:=True:C214  //kill the schedular
		If (Not:C34(Semaphore:C143("$Events_Running"; 60*5)))  //kill the listeners
			For ($event; 1; Size of array:C274(<>pid_call_back))
				RESUME PROCESS:C320(<>pid_call_back{$event})
			End for 
			ARRAY INTEGER:C220(<>pid_call_back; 0)
			ARRAY LONGINT:C221(<>pid_interval; 0)
			ARRAY LONGINT:C221(<>pid_event_time; 0)
			ARRAY INTEGER:C220(<>pid_wait_until_complete; 0)
			CLEAR SEMAPHORE:C144("$Events_Running")
		End if 
End case 