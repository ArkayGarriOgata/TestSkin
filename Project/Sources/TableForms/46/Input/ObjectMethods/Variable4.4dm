If (Form event code:C388=On Clicked:K2:4)
	If ([Customers_ReleaseSchedules:46]Promise_Date:32#!00-00-00!)
		Cal_getDate(->[Customers_ReleaseSchedules:46]Promise_Date:32; Month of:C24([Customers_ReleaseSchedules:46]Promise_Date:32); Year of:C25([Customers_ReleaseSchedules:46]Promise_Date:32))
	Else 
		Cal_getDate(->[Customers_ReleaseSchedules:46]Promise_Date:32)
	End if 
End if 
