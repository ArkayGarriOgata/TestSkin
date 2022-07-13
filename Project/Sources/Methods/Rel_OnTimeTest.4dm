//%attributes = {"publishedWeb":true}
//PM: Rel_OnTimeTest() -> 
//@author mlb - 6/18/01  10:34

If ([Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)
	$0:=util_iif([Customers_ReleaseSchedules:46]Actual_Date:7<=[Customers_ReleaseSchedules:46]Sched_Date:5; "On Time"; "Late")
Else 
	$0:="Late"
End if 