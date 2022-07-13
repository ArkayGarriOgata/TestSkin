UNLOAD RECORD:C212([ProductionSchedules:110])
READ WRITE:C146([ProductionSchedules:110])
LOAD RECORD:C52([ProductionSchedules:110])

If (Lvalue2=1)
	[ProductionSchedules:110]PlatesReady:18:=4D_Current_date
Else 
	[ProductionSchedules:110]PlatesReady:18:=!00-00-00!
End if 

SAVE RECORD:C53([ProductionSchedules:110])
UNLOAD RECORD:C212([ProductionSchedules:110])
READ ONLY:C145([ProductionSchedules:110])
LOAD RECORD:C52([ProductionSchedules:110])
