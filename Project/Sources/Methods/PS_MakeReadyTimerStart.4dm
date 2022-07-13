//%attributes = {"publishedWeb":true}
//PS_MakeReadyTimerStart

C_TIME:C306($0; tStart; $start)
C_BOOLEAN:C305(running)
C_TEXT:C284($event; $1)

If (<>pidTimer#0)
	$start:=Current time:C178
	If (Count parameters:C259=0)
		$event:="???"
	Else 
		$event:=$1
	End if 
	SET PROCESS VARIABLE:C370(<>pidTimer; tStart; $start; running; True:C214; makeSound; True:C214; sJobSeq; $event)
	zwStatusMsg("Start TIMER"; String:C10($start; HH MM SS:K7:1)+" = start")
	
Else 
	$0:=?00:00:00?
End if 