//%attributes = {"publishedWeb":true}
//gBudgetsDel: Delete Job File [Budgets]

Case of 
	: ([Jobs:15]Status:4#"Opened") & ([Jobs:15]Status:4#"Kill") & ([Jobs:15]Status:4#"Planned")
		ALERT:C41("Job status must be Opened, Kill, or Planned in order to delete Bugdet.")
	: ([Job_Forms:42]Status:6#"Opened") & ([Job_Forms:42]Status:6#"Kill") & ([Job_Forms:42]Status:6#"Planned")
		ALERT:C41("Job Form status must be Opened, Kill, or Planned in order to delete Bugdet.")
	Else 
		gDeleteRecord(->[Job_Forms_Machines:43])
		RELATE MANY:C262([Job_Forms:42]JobFormID:5)
End case 