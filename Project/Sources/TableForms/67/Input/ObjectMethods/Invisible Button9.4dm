If ([Job_Forms_Master_Schedule:67]Printed:32#!00-00-00!)
	Cal_getDate(->[Job_Forms_Master_Schedule:67]Printed:32; Month of:C24([Job_Forms_Master_Schedule:67]Printed:32); Year of:C25([Job_Forms_Master_Schedule:67]Printed:32))
Else 
	Cal_getDate(->[Job_Forms_Master_Schedule:67]Printed:32)
End if 
//
//•120998  MLB Y2K Remediation 
C_LONGINT:C283($err)
$err:=sDateLimitor(->[Job_Forms_Master_Schedule:67]Printed:32; 365)
If ([Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!)
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]Printed:32; -(14+(256*12)))  //grey
Else 
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]Printed:32; -(15+(256*12)))  //
	If (JOB_isValidForm([Job_Forms_Master_Schedule:67]JobForm:4))
		READ WRITE:C146([ProductionSchedules:110])
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=([Job_Forms_Master_Schedule:67]JobForm:4+"@"))
		If (Records in selection:C76([ProductionSchedules:110])>0)
			CONFIRM:C162("Remove this job from the Press Schedule?")
			If (ok=1)
				DELETE SELECTION:C66([ProductionSchedules:110])
			End if 
		End if 
		REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
		READ ONLY:C145([ProductionSchedules:110])
	End if   //got a job
End if 