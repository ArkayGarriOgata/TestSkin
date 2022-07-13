//%attributes = {}
// _______
// Method: util_Pause   (waitUntilTime ) ->
// By: Mel Bohince @ 04/15/21, 12:01:05
// Description
// 
// ----------------------------------------------------

C_TIME:C306($waitUntilTime; $1)
C_BOOLEAN:C305($exit)
$exit:=False:C215
C_LONGINT:C283($resolution; $minutes)
$minutes:=5
$resolution:=$minutes*60*60  //how often to wake and check the time, in ticks

If (Count parameters:C259=1)
	$waitUntilTime:=$1
Else 
	$waitUntilTime:=?14:31:00?
End if 

Repeat 
	
	If (4d_Current_time>=$waitUntilTime)
		$exit:=True:C214
	Else 
		DELAY PROCESS:C323(Current process:C322; $resolution)
	End if 
	
Until ($exit) | (<>fQuit4D)


If (Count parameters:C259=0)
	BEEP:C151
	ALERT:C41(String:C10(4d_Current_time))
End if 
