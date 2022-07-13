//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/04/07, 09:35:37
// ----------------------------------------------------
// Method: util_ForceQuitUsers
// Description
// look for shutdown flag
//
// Parameters
// ----------------------------------------------------
C_TEXT:C284($1)

If (Count parameters:C259=0)
	READ ONLY:C145([z___Kill_User_Processes:50])  //see 00_Logoff_Users and util_StartMaintenanceMode
	ALL RECORDS:C47([z___Kill_User_Processes:50])
	If (Records in selection:C76([z___Kill_User_Processes:50])>0)
		If ([z___Kill_User_Processes:50]_STOP_NOW_:2)
			If (User in group:C338(Current user:C182; "RoleSuperUser"))
				uConfirm("Confirm Kill Sequence"; "KILL"; "Stay Alive")
				If (ok=1)
					zwStatusMsg("MAINT MODE"; "Forcing Shutdown")
					BEEP:C151
					BEEP:C151
					BEEP:C151
					BEEP:C151
					DELAY PROCESS:C323(Current process:C322; 5*60)
					Quit4D
				End if 
				
			Else 
				zwStatusMsg("MAINT MODE"; "Forcing Shutdown")
				BEEP:C151
				BEEP:C151
				BEEP:C151
				BEEP:C151
				DELAY PROCESS:C323(Current process:C322; 5*60)
				Quit4D
			End if 
		End if 
	End if 
	
Else 
	READ WRITE:C146([z___Kill_User_Processes:50])  //see 00_Logoff_Users and util_StartMaintenanceMode
	ALL RECORDS:C47([z___Kill_User_Processes:50])
	If (Records in selection:C76([z___Kill_User_Processes:50])>0)
		If (User in group:C338(Current user:C182; "RoleSuperUser"))
			uConfirm("Log Users Out?"; "KILL"; "Allow")
			If (ok=1)
				[z___Kill_User_Processes:50]_STOP_NOW_:2:=True:C214
			Else 
				[z___Kill_User_Processes:50]_STOP_NOW_:2:=False:C215
			End if 
			SAVE RECORD:C53([z___Kill_User_Processes:50])
			UNLOAD RECORD:C212([z___Kill_User_Processes:50])
			
		End if 
	End if 
End if 