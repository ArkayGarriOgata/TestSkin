//%attributes = {}
// -------
// Method: Que_AddToQueue   ( ) ->
// By: Mel Bohince @ 06/09/17, 10:03:20
// Description
// add an event to the Scheduler queue
// ----------------------------------------------------
C_LONGINT:C283($1)
C_TEXT:C284($2; $3; $4)

If (<>ScheduleReady)
	//While (Semaphore("$que_in_use"))
	//IDLE
	//zwStatusMsg ("$que_in_use";"Waiting "+String(Tickcount))
	//DELAY PROCESS(Current process;10)
	//End while 
	APPEND TO ARRAY:C911(<>aScheduledUUID; Generate UUID:C1066)
	APPEND TO ARRAY:C911(<>aScheduled; $1)
	APPEND TO ARRAY:C911(<>aScheduledCallback; $2)
	APPEND TO ARRAY:C911(<>aScheduledContext; $3)
	APPEND TO ARRAY:C911(<>aScheduledParams; $4)
	Que_Display("sorted")
	//CLEAR SEMAPHORE("$que_in_use")
	
Else 
	BEEP:C151
	ALERT:C41("Queue not initialized")
End if 
