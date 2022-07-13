//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: IdleMonitor_Event - Created v0.1.0-JJG (02/03/16)
// Modified by: Mel Bohince (3/21/17) installed by IdleMonitor_InitEventCall

If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

If ((MouseDown>0) | (KeyCode#0))
	<>xlLastUserActivity:=Tickcount:C458
End if 


If (<>fHasPriorEvent)
	If (Length:C16(<>ttPriorEventCall)>0)  //paranoia/nested so both aren't evaluated
		ON ERR CALL:C155("e_EmptyErrorMethod")
		EXECUTE METHOD:C1007(<>ttPriorEventCall)
		If (OK=0)
			<>ttPriorEventCall:=""
		End if 
		ON ERR CALL:C155("")
	End if 
End if 

