//%attributes = {"publishedWeb":true}
//Procedure: zwStatusMsg("WARNING";" aMs connections are not available.")  020597 
//send a msg to the status bar
//•020298  MLB  allow it to be hidden

C_TEXT:C284($1; $2)
If (Not:C34(Application type:C494=4D Server:K5:6))
	If (Count parameters:C259=2)
		
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			While (Semaphore:C143("$isStatusBuzy"))
				IDLE:C311
				DELAY PROCESS:C323(Current process:C322; 10)
			End while 
			
			<>Status1:=" "+$1
			<>Status2:=" "+$2
			<>StatusPage:=1
			
			SHOW PROCESS:C325(<>StatusBar)  //•020298  MLB 
			POST OUTSIDE CALL:C329(<>StatusBar)
			CLEAR SEMAPHORE:C144("$isStatusBuzy")
			
		Else 
			If (<>StatusBar#0)
				While (Semaphore:C143("$isStatusBuzy"; 1000))
					IDLE:C311
				End while 
				
				<>Status1:=" "+$1
				<>Status2:=" "+$2
				<>StatusPage:=1
				
				SHOW PROCESS:C325(<>StatusBar)  //•020298  MLB 
				POST OUTSIDE CALL:C329(<>StatusBar)
				CLEAR SEMAPHORE:C144("$isStatusBuzy")
			End if 
		End if   // END 4D Professional Services : January 2019 query selection
		
	Else 
		BEEP:C151
		ALERT:C41("2 parameters required in status bar.")
	End if 
	
Else 
	utl_Logfile("statusbar.log"; "StatusBar: "+$1+": "+$2)
End if 
//