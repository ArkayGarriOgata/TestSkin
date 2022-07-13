//FM: PressSchedule() -> 
//@author mlb - 12/4/01  14:45
C_TEXT:C284(ttGotoOperationID)
Case of 
	: (Form event code:C388=On Clicked:K2:4)
		otpct:=[ProductionSchedules:110]Customer:11+" was On-time: "+OnTime_getRecent(""; [ProductionSchedules:110]Customer:11)
		If (Length:C16([ProductionSchedules:110]Comment:22)>0)
			zwStatusMsg(<>jobform; TS2String(TSTimeStamp([ProductionSchedules:110]EndDate:6; [ProductionSchedules:110]EndTime:7))+" "+[ProductionSchedules:110]Comment:22)  //"End+Comments"
		Else 
			zwStatusMsg(<>jobform; TS2String(TSTimeStamp([ProductionSchedules:110]EndDate:6; [ProductionSchedules:110]EndTime:7)))  //"End Date & Time"
		End if 
		
	: (Form event code:C388=On Menu Selected:K2:14)
		$err:=PS_menu_mgr("do"; Menu selected:C152)
		
	: (Form event code:C388=On Timer:K2:25)
		// Added by: Mel Bohince (5/30/19) stop the lock record dialog from coming up when multi schd windows open
		If (Semaphore:C143("$SchdUpdateChk"; 300))
			// We expected 300 ticks but the semaphore
			// was not released by the one that placed it:
			// we end up here
		Else 
			User_NotifyCheck
			CLEAR SEMAPHORE:C144("$SchdUpdateChk")
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		$restricted:=Read only state:C362([ProductionSchedules:110])
		If (Not:C34($restricted))
			//uConfirm ("Notify "+sCriterion1+" users of schedule change?";"Yes";"No")
			//If (ok=1)
			//User_NotifyAll 
			//User_NotifySet (sCriterion1)
			//End if 
		End if 
		CANCEL:C270
		
	: (Form event code:C388=On Outside Call:K2:11)
		PS_EventOnOutsideCall
		
		
	: (Form event code:C388=On Load:K2:1)
		PS_EventOnLoad
		$err:=PS_menu_mgr("make")
		
End case 


//v1.0.0-PJK (12/17/15) add code to auto highlight the operation when viewed from the Advanced Scheduler

If (ttGotoOperationID#"")  //v1.0.0-PJK (12/17/15)
	ARRAY TEXT:C222($sttIDs; 0)
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		SELECTION TO ARRAY:C260([ProductionSchedules:110]JobSequence:8; $sttIDs)
		$xlFind:=Find in array:C230($sttIDs; ttGotoOperationID)
		If ($xlFind>0)
			GOTO SELECTED RECORD:C245([ProductionSchedules:110]; $xlFind)
			CREATE EMPTY SET:C140([ProductionSchedules:110]; "SelSet")
			ADD TO SET:C119([ProductionSchedules:110]; "SelSet")
			HIGHLIGHT RECORDS:C656([ProductionSchedules:110]; "SelSet")
			CLEAR SET:C117("SelSet")
		End if 
		
	Else 
		
		ARRAY LONGINT:C221($_record_number; 0)
		SELECTION TO ARRAY:C260([ProductionSchedules:110]JobSequence:8; $sttIDs; [ProductionSchedules:110]; $_record_number)
		$xlFind:=Find in array:C230($sttIDs; ttGotoOperationID)
		If ($xlFind>0)
			ARRAY LONGINT:C221($_record_finale; 0)
			APPEND TO ARRAY:C911($_record_finale; $_record_number{$xlFind})
			CREATE SET FROM ARRAY:C641([ProductionSchedules:110]; $_record_finale; "SelSet")
			HIGHLIGHT RECORDS:C656([ProductionSchedules:110]; "SelSet")
			CLEAR SET:C117("SelSet")
		End if 
		
	End if   // END 4D Professional Services : January 2019 
	
	ttGotoOperationID:=""  //v1.0.0-PJK (12/17/15)
End if   //v1.0.0-PJK (12/17/15)
