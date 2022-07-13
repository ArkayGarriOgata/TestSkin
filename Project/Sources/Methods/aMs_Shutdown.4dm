//%attributes = {}
// Method: aMs_Shutdown () -> 
// ----------------------------------------------------
// by: mel: 11/03/03, 16:15:20
// ----------------------------------------------------
//(P) quit4D
//051295 Remove quit comfirmation
//•022597  MLB  clear sets
//• 7/14/97 cs added code to wake any sleeping processes & the activate
//  so that they (notifier especially) can shut down correctly
//• 4/23/98 cs added code to handle Faxwatcher since it may delay AMS quit
//• mlb - 6/20/02  10:16 remove Faxwatcher delay

C_LONGINT:C283($id; $state)

zwStatusMsg("SHUTDOWN"; "Cleaning up")
<>fQuit4D:=True:C214
<>delayCanceled:=True:C214

GET WINDOW RECT:C443(<>mewLeft; <>mewTop; <>mewRight; <>mewBottom; <>MainEventWindow)  //save the window position
If (<>TEST_VERSION)
	<>mewRight:=<>mewRight-10
	<>mewBottom:=<>mewBottom-24
End if 
$remembered:=New process:C317("util_SetWindowPosition"; <>lMinMemPart; "Saving User Preference"; "MainEventWindow"; <>mewLeft; <>mewTop; <>mewRight; <>mewBottom)
DELAY PROCESS:C323(Current process:C322; 20)

If (<>pidTimer#0)
	PS_MakeReadyTimer(0)
End if 

If (<>FloatingAlert_PID#0)
	util_FloatingAlert("Quitting")
End if 

If (<>pid_eBag#0)
	SHOW PROCESS:C325(<>pid_eBag)
	POST OUTSIDE CALL:C329(<>pid_eBag)
End if 

For ($id; 1; Count tasks:C335)  //force all running processes to become alert to quit of program
	$State:=Process state:C330($id)
	zwStatusMsg("SHUTDOWN"; "Cleaning up pid:"+String:C10($id)+" "+String:C10($State))
	Case of 
		: ($State=Delayed:K13:2)
			DELAY PROCESS:C323($id; 0)
		: ($State=Paused:K13:6)  //paused or delayed
			RESUME PROCESS:C320($id)  //wake it up
	End case 
	
	POST OUTSIDE CALL:C329($id)
End for 

For ($id; 1; Get last table number:C254)  //•022597  MLB  
	If (Is table number valid:C999($id))
		zwStatusMsg("SHUTDOWN"; "Cleaning up set "+"◊LastSelection"+String:C10($id))
		CLEAR SET:C117("◊LastSelection"+String:C10($id))
	End if 
End for 

ACCEPT:C269
FLUSH CACHE:C297

<>COM_SerialPortActive:=False:C215

CLEAR SEMAPHORE:C144(Current user:C182)  //clear semaphore set at logging

If (<>Sync_Activated)
	If (Application type:C494#4D Remote mode:K5:5)
		//GNS_Sync ("OnQuit")
	End if 
End if 

If (<>FLEX_EXCHG_PID#0)
	DELAY PROCESS:C323(<>FLEX_EXCHG_PID; 0)
End if 

If (<>pid_Usage#0)
	app_Log_Usage("kill"; ""; "")
End if 

If (<>EDI_ASN_pid#0)  // Modified by: Mel Bohince (2/28/20) 
	<>EDI_ASN_keep_running:=False:C215
End if 
//If (<>PING_PID#0)
//DELAY PROCESS(<>PING_PID;0)
//End if 