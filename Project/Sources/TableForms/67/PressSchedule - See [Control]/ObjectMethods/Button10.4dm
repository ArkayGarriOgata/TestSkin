//bPrint 12/12/01 Systems G4
//
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	COPY NAMED SELECTION:C331([ProductionSchedules:110]; "Hold")
	
Else 
	
	
	ARRAY LONGINT:C221($_Hold; 0)
	LONGINT ARRAY FROM SELECTION:C647([ProductionSchedules:110]; $_Hold)
	
End if   // END 4D Professional Services : January 2019 

$priority:=Request:C163("Print up to what priority?"; "100"; "Restrict"; "All")
If (ok=1)
	
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3<=(Num:C11($priority)))
	
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
	
End if 

If (cb1=1)
	xText:="Working Saturdays"
Else 
	xText:="No Saturdays"
End if 

If (cb2=1)
	xTitle:="Working Sundays"
Else 
	xTitle:="No Sundays"
End if 

t1:="As of "+String:C10(Current date:C33; System date short:K1:1)+" "+String:C10(Current time:C178; HH MM:K7:2)

FORM SET OUTPUT:C54([Job_Forms_Master_Schedule:67]; "PressSchedulePrint")
util_PAGE_SETUP(->[Job_Forms_Master_Schedule:67]; "PressSchedulePrint")
PRINT RECORD:C71([Job_Forms_Master_Schedule:67]; *)
FORM SET OUTPUT:C54([Job_Forms_Master_Schedule:67]; "List")
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	USE NAMED SELECTION:C332("Hold")
	CLEAR NAMED SELECTION:C333("Hold")
Else 
	
	CREATE SELECTION FROM ARRAY:C640([ProductionSchedules:110]; $_Hold)
	
End if   // END 4D Professional Services : January 2019 
