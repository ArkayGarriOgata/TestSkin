//%attributes = {"publishedWeb":true}
//PS_MakeReadyTimer 
//init the timer process
//mlb 07/16/03

C_LONGINT:C283($1)

If (Count parameters:C259=1)  //init
	If (<>pidTimer=0) | (Process state:C330(<>pidTimer)=Aborted:K13:1) | (Process state:C330(<>pidTimer)=Does not exist:K13:3)
		<>pidTimer:=New process:C317("PS_MakeReadyTimer"; <>lMinMemPart; "TIMER")
		If (False:C215)
			PS_MakeReadyTimer
		End if 
		DELAY PROCESS:C323(Current process:C322; 20)
	Else   //allreaday running
		If ($1=1)  //show
			SHOW PROCESS:C325(<>pidTimer)
			//BRING TO FRONT(◊pidTimer)
		Else   //kill see quit4D
			SHOW PROCESS:C325(<>pidTimer)
			BRING TO FRONT:C326(<>pidTimer)
			POST OUTSIDE CALL:C329(<>pidTimer)
		End if 
	End if 
	
Else 
	SET MENU BAR:C67(<>DefaultMenu)
	C_TIME:C306(tEnd; tTime; tStart)
	C_LONGINT:C283(iLimit; iElapse; iRemaining; $winRef)
	C_BOOLEAN:C305(running; makeSound)
	C_TEXT:C284(sJobSeq)
	iLimit:=0  //set by PS_MakeReadyTimerSet
	iElapse:=0  //iElapse:=$now-tStart  recalcd by OnTimer event
	iRemaining:=0  //iRemaining:=tEnd-$now  recalcd by OnTimer event
	tEnd:=?00:00:00?  //tEnd:=tStart+iLimit recalcd by OnTimer event
	tStart:=?00:00:00?  //set by PS_MakeReadyTimerStart
	tTime:=?00:00:00?  //value that is displayed  tTime:=tEnd-$now
	running:=False:C215  //to skip the OnTimer event, set by PS_MakeReadyTimerStart & 
	//                             PS_MakeReadyTimerStop
	makeSound:=True:C214  // give em one beep when you reach 00:00 `set by PS_MakeReadyTimerStart
	sJobSeq:=""  //set by PS_MakeReadyTimerStart
	
	C_TEXT:C284(windowTitle)
	//$winRef:=Open form window([ProductionSchedules];"MakeReadyTimer_dio";-8)
	//SET WINDOW TITLE(windowTitle)
	windowTitle:="Make Ready Timer"+" pid="+String:C10(Current process:C322)
	//SET WINDOW TITLE(windowTitle)
	$winRef:=OpenFormWindow(->[ProductionSchedules:110]; "MakeReadyTimer_dio"; ->windowTitle; windowTitle)
	C_LONGINT:C283(left; top; right; bottom)  //move to last position
	C_BOOLEAN:C305($remembered; $inbounds)
	$remembered:=util_GetWindowPosition("TIMER"; ->left; ->top; ->right; ->bottom)
	$inbounds:=util_ScreenCoordinatesInbounds(left; top; right; bottom)
	If ($inbounds) & ($remembered)
		SET WINDOW RECT:C444(left; top; right; bottom; $winRef)
	End if 
	
	//HIDE PROCESS(Current process)
	DIALOG:C40([ProductionSchedules:110]; "MakeReadyTimer_dio")
	
	GET WINDOW RECT:C443(left; top; right; bottom; $winRef)  //save the window position
	$remembered:=util_SetWindowPosition("TIMER"; left; top; right; bottom)
	
	CLOSE WINDOW:C154($winRef)
	
	<>pidTimer:=0
	
End if 