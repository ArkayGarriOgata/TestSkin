If ([Estimates_DifferentialsForms:47]DateCustomerWant:7#!00-00-00!)
	Cal_getDate(->[Estimates_DifferentialsForms:47]DateCustomerWant:7; Month of:C24([Estimates_DifferentialsForms:47]DateCustomerWant:7); Year of:C25([Estimates_DifferentialsForms:47]DateCustomerWant:7))
Else 
	Cal_getDate(->[Estimates_DifferentialsForms:47]DateCustomerWant:7)
End if 
//
//•120998  MLB Y2K Remediation 
//• mlb - 3/4/03  12:15 subform fix
C_LONGINT:C283($err)
$err:=sDateLimitor(->[Estimates_DifferentialsForms:47]DateCustomerWant:7; 565)
If ($err#0)
	[Estimates_DifferentialsForms:47]DateCustomerWant:7:=Old:C35([Estimates_DifferentialsForms:47]DateCustomerWant:7)
End if 