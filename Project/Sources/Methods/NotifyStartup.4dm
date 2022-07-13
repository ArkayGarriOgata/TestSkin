//%attributes = {"publishedWeb":true}
//(p) NotifyStartup
//starts the notification manager
//• 7/8/97 cs created
//• 7/21/97 cs added second flag to stop process

C_BOOLEAN:C305(<>fWindowOpen)
C_LONGINT:C283($NotifyProc; $ID)

MESSAGES OFF:C175

<>fWindowOpen:=False:C215

Repeat 
	<>fSearchDone:=False:C215
	$ID:=New process:C317("NotifySearch"; <>lMinMemPart; "•NotifySearch")  //do searches needed in non-local processes
	
	Repeat 
		DELAY PROCESS:C323(Current process:C322; 60)  //wait for search to complete
	Until (<>fSearchDone)
	<>fSearchDone:=False:C215
	
	If (<>fWindowOpen)  //if first time no window open!
		POST OUTSIDE CALL:C329($NotifyProc)
	Else 
		If (<>xMsgText#"Nothing Pending")  //message text to process
			$NotifyProc:=New process:C317("Notifier"; <>lMinMemPart; "$•Notifier")
		Else 
			$NotifyProc:=New process:C317("Notifier"; <>lMinMemPart; "$•Notifier")
			DELAY PROCESS:C323(Current process:C322; 600)  //delay 10 seconds
			$NotifyProc:=uProcessID("$•Notifier")  //insure that user did not close already
			
			If ($NotifyProc>0)  //if user has not closed the window - do so for them
				<>fQuitNotify:=True:C214
				POST OUTSIDE CALL:C329($NotifyProc)
				<>fQuitNotify:=True:C214
			End if 
		End if 
	End if 
	DELAY PROCESS:C323(Current process:C322; 3600*<>PrefTime)
	
Until (<>fQuit4D) | (<>fQuitNotify)

MESSAGES ON:C181