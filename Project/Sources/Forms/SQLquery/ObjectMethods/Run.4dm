
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/21/10, 19:32:31
// ----------------------------------------------------
// Method: Object Method: SQLquery.b1
// Description
// 
//
// Parameters
// ----------------------------------------------------

If (Substring:C12(tText; 1; 6)="SELECT")
	$temp:=tText
	//SQL LOGIN(SQL_INTERNAL ;"";"")  `current user
	tText:=tText+" INTO <<Box1>>"
	
	If (Not:C34(local_db))
		If (WMS_SQL_Login)
			zwStatusMsg("SQL..."; "Running...")
		Else 
			zwStatusMsg("SQL..."; "Could not log into WMS, \rclose window and try again.")
		End if 
	End if 
	$t1:=Milliseconds:C459
	Begin SQL
		EXECUTE IMMEDIATE :tText
	End SQL
	$elapse:=Milliseconds:C459-$t1
	
	If (Not:C34(local_db))
		SQL LOGOUT:C872
		zwStatusMsg("SQL..."; "milliseconds = "+String:C10($elapse)+"  Logged out...")
		
	Else 
		zwStatusMsg("SQL..."; "milliseconds = "+String:C10($elapse))
	End if 
	tText:=$temp
	
	LISTBOX SET FOOTER CALCULATION:C1140(*; "Results"; lk footer count:K70:5)
	
Else 
	ALERT:C41("You may only use an sql SELECT command here.")
End if 

