//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: IdleMonitor_Proc - Created v0.1.0-JJG (02/03/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283(<>xlGracePeriod; <>xlMaxIdlePeriod; <>xlKeystrokePeriod; <>xlIdleMonitorProcessPeriod)
C_LONGINT:C283(<>xlLastUserActivity)
<>fHasPriorEvent:=False:C215
<>ttPriorEventCall:=""

If ((Application type:C494#4D Server:K5:6) & Not:C34(IdleMonitor_ExemptUser))  // users in group "ExemptFromTimeOut" arenot effected
	
	<>xlLastUserActivity:=Tickcount:C458
	Repeat 
		DELAY PROCESS:C323(Current process:C322; <>xlIdleMonitorProcessPeriod)  //30 seconds
		
		IdleMonitor_InitEventCall
		
		Case of 
			: ((Tickcount:C458-<>xlLastUserActivity)<<>xlMaxIdlePeriod)
				
			: (IdleMonitor_IsActive)  // no activity detected, so ping the user
				
			Else 
				BEEP:C151
				BEEP:C151
				BEEP:C151
				utl_LogfileServer(<>zResp; "IdleMonitor_Proc called Quit4D"; "client.log")  // Modified by: Mel Bohince (11/20/18) 
				//utl_Logfile ("client.log";"IdleMonitor_Proc called Quit4D")  // Modified by: Mel Bohince (3/21/17) leave breadcrumb for why quit happened
				Quit4D
				
		End case 
	Until (Process aborted:C672)
	
End if 

