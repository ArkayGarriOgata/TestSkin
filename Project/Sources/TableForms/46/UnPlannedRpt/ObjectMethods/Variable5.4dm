//(s0 rDate
//rDate - reused from symbol table

If ([Customers_ReleaseSchedules:46]Sched_Date:5>4D_Current_date)
	Self:C308->:="Past Due"
Else 
	Self:C308->:=String:C10(4D_Current_date-[Customers_ReleaseSchedules:46]Sched_Qty:6; "##0.0")
End if 
