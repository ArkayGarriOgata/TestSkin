//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: IdleMonitor_InitEventCall - Created v0.1.0-JJG (02/03/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($ttIdleMonitorEventCallMethod; $ttPriorEventCall)
$ttIdleMonitorEventCallMethod:="IdleMonitor_Event"


$ttPriorEventCall:=Method called on event:C705

Case of 
	: ($ttPriorEventCall=$ttIdleMonitorEventCallMethod)
		//state has not changed - do nothing
		
	: ($ttPriorEventCall="")  //cleared, redo idlemonitor event
		<>fHasPriorEvent:=False:C215
		<>ttPriorEventCall:=""
		ON EVENT CALL:C190($ttIdleMonitorEventCallMethod)
		
	: ($ttPriorEventCall#<>ttPriorEventCall)  // new event method
		<>fHasPriorEvent:=True:C214
		<>ttPriorEventCall:=$ttPriorEventCall
		ON EVENT CALL:C190($ttIdleMonitorEventCallMethod)
		
		
		
		
End case 

