If (Rama_Find_Payables("user_specified2")>0)
	Rama_Load_Transactions
	REDRAW:C174(InvListBox)
	
Else 
	uConfirm("No transactions found."; "OK"; "Help")
End if 