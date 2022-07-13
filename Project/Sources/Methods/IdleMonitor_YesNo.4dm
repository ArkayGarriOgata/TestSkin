//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: IdleMonitor_YesNo - Created v0.1.0-JJG (02/03/16)
// Modified by: Mel Bohince (3/21/17) forked by IdleMonitor_IsActive
// give the user a chance to stay logged in 

If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

BEEP:C151
BEEP:C151
BEEP:C151
If (YESNO("Are you still using AMS?"))
	
	<>xlLastUserActivity:=Tickcount:C458
	
End if 