//OM: bMove() -> 
//@author mlb - 12/5/01  12:01

If (sCriterion1=[ProductionSchedules:110]CostCenter:1)
	$press:=Request:C163("Move to which press?"; "412 or 416 or 415"; "Move"; "Cancel")
	If (ok=1)
		//COPY NAMED SELECTION([PressSchedule];"sched")
		CUT NAMED SELECTION:C334([Cost_Centers:27]; "cc")
		QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$press)
		
		If (Records in selection:C76([Cost_Centers:27])>0)
			$toDelete:=Record number:C243([ProductionSchedules:110])
			DUPLICATE RECORD:C225([ProductionSchedules:110])
			[ProductionSchedules:110]pk_id:77:=Generate UUID:C1066
			[ProductionSchedules:110]CostCenter:1:=$press
			[ProductionSchedules:110]Name:2:=[Cost_Centers:27]Description:3
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[ProductionSchedules]z_SYNC_ID;->[ProductionSchedules]z_SYNC_DATA)
			
			SAVE RECORD:C53([ProductionSchedules:110])
			
			GOTO RECORD:C242([ProductionSchedules:110]; $toDelete)
			DELETE RECORD:C58([ProductionSchedules:110])
			
			$pressPtr:=Get pointer:C304("◊pid"+$press)
			SHOW PROCESS:C325($pressPtr->)
			BRING TO FRONT:C326($pressPtr->)
			POST OUTSIDE CALL:C329($pressPtr->)
			
		Else 
			BEEP:C151
			ALERT:C41($press+" was not found.")
		End if 
		
		USE NAMED SELECTION:C332("cc")
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=sCriterion1)
		If (Records in selection:C76([ProductionSchedules:110])>0)
			pressBackLog:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600
			ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; >; [ProductionSchedules:110]StartDate:4; >)
		Else 
			pressBackLog:=0
		End if 
		FORM GOTO PAGE:C247(1)
		//USE NAMED SELECTION("sched")
		//CLEAR NAMED SELECTION("sched")
		
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Please select the job sequence to move.")
End if 