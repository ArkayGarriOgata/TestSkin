//(s)  bDeptBudgets
//launch the department budget pallette
//• CS 10/13/95 created
If (Current user:C182="Designer") | (User in group:C338(Current user:C182; "Dept Budgets"))
	If (<>BudgetProc#0)
		BRING TO FRONT:C326(<>BudgetProc)
	Else 
		ALERT:C41("`◊BudgetProc:=uSpawnPalette ('BudgetPallet';'$Department Budgets')")
	End if 
Else 
	uNotAuthorized
End if 

If (False:C215)  //insider
	//BudgetPallet 
End if 
//eop