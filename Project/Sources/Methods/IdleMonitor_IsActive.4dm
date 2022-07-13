//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: IdleMonitor_IsActive - Created v0.1.0-JJG (02/03/16)
// Modified by: Mel Bohince (3/21/17) called by IdleMonitor_Proc
// no activity detected, so ping the user

If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0)
C_LONGINT:C283($xlStart; $xlNow; $xlPID; $xlOldLastActivity)
$xlStart:=Tickcount:C458
$xlNow:=Tickcount:C458
$xlOldLastActivity:=<>xlLastUserActivity

$xlPID:=New process:C317("IdleMonitor_YesNo"; <>lBigMemPart; "IdleEnquiry")

Repeat 
	
	DELAY PROCESS:C323(Current process:C322; 60*60)
	
Until ((($xlNow-$xlStart)<<>xlGracePeriod) | ($xlOldLastActivity#<>xlLastUserActivity))

$0:=($xlOldLastActivity#<>xlLastUserActivity)