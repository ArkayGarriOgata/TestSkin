//%attributes = {}
//  OBSOLETE
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 01/26/11, 16:44:44
// ----------------------------------------------------
// Method: util_ping_server
// Description
// not really a ping, just a request for server's date and time
// so idle connection doesn't die
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283(<>PING_PID; $delay_in_ticks)
$delay_in_ticks:=60*60*2  //two minutes
If (Count parameters:C259=0)
	<>PING_PID:=New process:C317("util_ping_server"; <>lMinMemPart; "Ping Server"; "init")
	
Else 
	Repeat 
		DELAY PROCESS:C323(Current process:C322; $delay_in_ticks)
		//below works but annoys some picky users
		//zwStatusMsg ("PING";String(4D_Current_date;System date long )+" at "+String(4d_Current_time;System time long ))
		$date:=4D_Current_date
		$time:=4d_Current_time
		
	Until (<>fQuit4D)
End if 
