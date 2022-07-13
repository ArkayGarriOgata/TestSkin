If (Form event code:C388=On Clicked:K2:4)
	If ([Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
		Cal_getDate(->[Customers_ReleaseSchedules:46]Sched_Date:5; Month of:C24([Customers_ReleaseSchedules:46]Sched_Date:5); Year of:C25([Customers_ReleaseSchedules:46]Sched_Date:5))
	Else 
		Cal_getDate(->[Customers_ReleaseSchedules:46]Sched_Date:5)
	End if 
End if 

[Customers_ReleaseSchedules:46]Sched_Date:5:=REL_NoWeekEnds([Customers_ReleaseSchedules:46]Sched_Date:5)  // • mel (6/22/05, 17:08:14)

If ([Customers_ReleaseSchedules:46]Promise_Date:32=!00-00-00!)
	[Customers_ReleaseSchedules:46]Promise_Date:32:=[Customers_ReleaseSchedules:46]Sched_Date:5
End if 

If ([Customers_ReleaseSchedules:46]Entered_Date:34=!00-00-00!)
	[Customers_ReleaseSchedules:46]Entered_Date:34:=4D_Current_date
End if 

If ([Customers_ReleaseSchedules:46]Sched_Date:5>=releaseFence)
	If (Record number:C243([Customers_ReleaseSchedules:46])#-3)
		[Customers_ReleaseSchedules:46]ChgDateVersion:15:=[Customers_ReleaseSchedules:46]ChgDateVersion:15+1
	End if 
	
	If ([Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)
		lValue1:=[Customers_ReleaseSchedules:46]Sched_Date:5-[Customers_ReleaseSchedules:46]Actual_Date:7
	End if 
	
Else 
	BEEP:C151  //6/17/03 let everyone change because metric is only on promise date
	If (False:C215)  // (Not(User in group(Current user;"RoleManagementTeam")))
		ALERT:C41(String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)+" is before the current Available-To-Promise of "+String:C10(releaseFence; System date short:K1:1); "Use Best Date")
		[Customers_ReleaseSchedules:46]Sched_Date:5:=releaseFence
	Else 
		CONFIRM:C162(String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)+" is before the current Available-To-Promise of "+String:C10(releaseFence; System date short:K1:1); "Permit"; "Deny")
		If (ok=0)
			[Customers_ReleaseSchedules:46]Sched_Date:5:=releaseFence
		End if 
	End if 
End if 