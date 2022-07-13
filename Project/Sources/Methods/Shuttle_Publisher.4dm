//%attributes = {}
// -------
// Method: Shuttle_Publisher   ( ) ->
// By: Mel Bohince @ 06/09/17, 12:49:30
// Description
// 
// ----------------------------------------------------
C_BOOLEAN:C305(<>Shuttle_Publish_On)
C_LONGINT:C283(<>pid_Shuttle_Publish)
C_TEXT:C284($hotFolder)

$hotFolder:=System folder:C487(Desktop:K41:16)
$hotFolder:=Replace string:C233($hotFolder; "Desktop"; "Dropbox")+"shuttle_inbox:"

If (Test path name:C476($hotFolder)=Is a folder:K24:2)
	CONFIRM:C162("Shuttle_Publisher?"; "Turn On"; "Turn Off")
	If (ok=1)
		utl_Logfile("que_scheduler.log"; "Start requested")
		<>Shuttle_Publish_On:=True:C214
		<>pid_Shuttle_Publish:=New process:C317("Shuttle_Post"; <>lMinMemPart; "Shuttle_Post")
		
		//DELAY PROCESS(Current process;60)
		//$nextRun:=TSTimeStamp +10
		//Que_AddToQueue ($nextRun;"Shuttle_Post";"client";"repeat")
		
	Else 
		<>Shuttle_Publish_On:=False:C215
		utl_Logfile("que_scheduler.log"; "Stop requested")
	End if 
	
Else 
	BEEP:C151
	utl_Logfile("que_scheduler.log"; "'"+$hotFolder+"' was not found.")
End if 