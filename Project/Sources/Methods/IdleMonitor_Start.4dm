//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: IdleMonitor_Start - Created v0.1.0-JJG (02/03/16)
// Modified by: Mel Bohince (3/21/17) called from startup

If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($xlPID; $second; $minute)
$second:=60  //convert ticks to seconds
$minute:=60*$second  //3600 ticks

<>xlIdleMonitorProcessPeriod:=30*$second  //ticks - process checks every... 30 seconds

<>xlGracePeriod:=1*$minute  //ticks - user has this long to response to pop-up... minute to respond

<>xlMaxIdlePeriod:=1.5*60*$minute  // Modified by: Mel Bohince (2/11/16) increase to 1 hour  // Modified by: Mel Bohince (2/20/16) increase to 1.5 hours

<>xlKeystrokePeriod:=25*$minute  //ticks - start monitoring keystrokes after this time - not yet used

$xlPID:=New process:C317("IdleMonitor_Proc"; <>lBigMemPart; "$IdleMonitor")

//<>xlIdleMonitorProcessPeriod:=30*60  //ticks - process checks every

//<>xlGracePeriod:=1*60*60  //ticks - user has this long to response to pop-up

//<>xlMaxIdlePeriod:=30*60*60  //ticks - user can only be inactive this long before prompted

//<>xlKeystrokePeriod:=25*60*60  //ticks - start monitoring keystrokes after this time - not yet used