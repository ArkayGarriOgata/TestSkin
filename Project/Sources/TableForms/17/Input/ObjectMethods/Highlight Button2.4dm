If ([Estimates:17]DateCustomerWant:23#!00-00-00!)
	Cal_getDate(->[Estimates:17]DateCustomerWant:23; Month of:C24([Estimates:17]DateCustomerWant:23); Year of:C25([Estimates:17]DateCustomerWant:23))
Else 
	Cal_getDate(->[Estimates:17]DateCustomerWant:23)
End if 
//
//•120998  MLB Y2K Remediation 
//• mlb - 3/4/03  12:15 subform fix
C_LONGINT:C283($err)
$err:=sDateLimitor(->[Estimates:17]DateCustomerWant:23; 565)
If ($err#0)
	[Estimates:17]DateCustomerWant:23:=Old:C35([Estimates:17]DateCustomerWant:23)
End if 