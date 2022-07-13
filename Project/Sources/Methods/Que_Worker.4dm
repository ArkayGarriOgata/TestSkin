//%attributes = {}
// -------
// Method: Que_Worker   ( ) ->
// By: Mel Bohince @ 06/08/17, 10:12:34
// Description
// do the work that Que_Scheduler delagates
// ----------------------------------------------------

C_TEXT:C284($1)  //uuid of event

$event:=Find in array:C230(<>aScheduledUUID; $1)
If ($event>-1)
	utl_Logfile("que_scheduler.log"; "Running "+<>aScheduledCallback{$event}+" ("+<>aScheduledParams{$event}+" )")
	If (<>aScheduledContext{$event}="client")
		If (Length:C16(<>aScheduledParams{$event})=0)
			EXECUTE METHOD:C1007(<>aScheduledCallback{$event})
		Else 
			EXECUTE METHOD:C1007(<>aScheduledCallback{$event}; *; <>aScheduledParams{$event})
		End if 
		
		If (ok=1)  //success, clear the event
			<>aScheduled{$event}:=0  //don't run again
		Else   //tag event as error
			utl_Logfile("que_scheduler.log"; "Failed: "+<>aScheduledCallback{$event})
		End if 
		
		
		
	Else   // server side not yet implemented
		//Execute on server ( procedure ; stack {; name {; param {; param2 ; ... ; paramN}}}{; *} ) //-> Function result 
	End if 
	
Else 
	utl_Logfile("que_scheduler.log"; "UUID Not found: "+$1)
End if 