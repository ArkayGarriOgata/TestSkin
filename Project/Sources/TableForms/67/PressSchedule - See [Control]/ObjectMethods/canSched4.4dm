//OM: bDel() -> 
//@author mlb - 12/5/01  12:01

If (sCriterion1=[ProductionSchedules:110]CostCenter:1)
	If ([ProductionSchedules:110]JobSequence:8#"Blocked")
		CONFIRM:C162("Set the 'Printed' date on the JobMasterLog?"; "Yes"; "No")
		If (ok=1)
			READ WRITE:C146([Job_Forms_Master_Schedule:67])
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=(Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)))
			If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)
				[Job_Forms_Master_Schedule:67]Printed:32:=Current date:C33
				SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
				REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
			Else 
				BEEP:C151
				zwStatusMsg("ERROR"; "Printed date could not be set on JobMasterLog")
			End if 
			
		End if 
	End if 
	DELETE RECORD:C58([ProductionSchedules:110])
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=sCriterion1)
	If (Records in selection:C76([ProductionSchedules:110])>0)
		pressBackLog:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600
		ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; >; [ProductionSchedules:110]StartDate:4; >)
	Else 
		pressBackLog:=0
	End if 
	FORM GOTO PAGE:C247(1)
	
Else 
	BEEP:C151
	ALERT:C41("Please select the job sequence to Delete.")
End if 