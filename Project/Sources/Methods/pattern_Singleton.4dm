//%attributes = {}
// Method: pattern_Singleton () -> 
// ----------------------------------------------------
// by: mel: 08/17/05, 12:43:31
// ----------------------------------------------------
// Description:
// use recursive method to launch a process, makes it self contained
//change the interprocess pid and the method in the new process command
// see also pattern_Self_calling_process
// ----------------------------------------------------

C_TEXT:C284($1; $2; $actionRequested; $searchParameter; windowTitle)  //search parameter on an update
C_LONGINT:C283(<>_PID; <>iMode)

Case of 
	: (Count parameters:C259=0)  //init the process
		If (<>_PID=0)  //singleton
			<>_PID:=New process:C317(Current method name:C684; 0; Current method name:C684; "new"; "")
		Else 
			SHOW PROCESS:C325(<>_PID)
		End if 
		
	: (Count parameters:C259=1)
		<>_PID:=New process:C317(Current method name:C684; 0; Current method name:C684; "update"; $1)
		
	Else 
		//do the deed
		$actionRequested:=$1
		$searchParameter:=$2
		Case of 
			: ($actionRequested="new")
				<>iMode:=1
				
			: ($actionRequested="update")
				<>iMode:=2
			Else 
				
		End case 
		<>filePtr:=->[Finished_Goods_PackingSpecs:91]
		uSetUp(1)
		
		windowTitle:=sFile+""
		$winRef:=OpenFormWindow(filePtr; "Input"; ->windowTitle; windowTitle)
		
		C_LONGINT:C283(iPSTabs)
		iPSTabs:=0
		
		Case of 
			: ($actionRequested="new")
				
			: ($actionRequested="update")
				
			Else 
				
		End case 
		
		CLOSE WINDOW:C154($winRef)
		REDUCE SELECTION:C351(filePtr->; 0)
End case 