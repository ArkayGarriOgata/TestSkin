If ([To_Do_Tasks:100]DateDue:10#!00-00-00!)
	Cal_getDate(->[To_Do_Tasks:100]DateDue:10; Month of:C24([To_Do_Tasks:100]DateDue:10); Year of:C25([To_Do_Tasks:100]DateDue:10))
Else 
	Cal_getDate(->[To_Do_Tasks:100]DateDue:10)
End if 
//