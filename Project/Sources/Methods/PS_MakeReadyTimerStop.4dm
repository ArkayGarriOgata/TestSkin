//%attributes = {"publishedWeb":true}
//PS_MakeReadyTimerStop

C_TIME:C306($0; $elapseTime; tStart; $start; $stop)
C_BOOLEAN:C305(running)

If (<>pidTimer#0)
	$stop:=Current time:C178
	GET PROCESS VARIABLE:C371(<>pidTimer; tStart; $start)
	SET PROCESS VARIABLE:C370(<>pidTimer; running; False:C215)
	$elapseTime:=$stop-$start
	$0:=$elapseTime
	zwStatusMsg("SET TIMER"; String:C10($elapseTime; HH MM SS:K7:1)+" = Limit  "+String:C10($stop; HH MM SS:K7:1)+" = stop")
	
Else 
	$0:=?00:00:00?
End if 