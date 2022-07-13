If (aSalesReps#0)  // & (Old(SalesmanID)="")
	[Customers:16]SalesmanID:3:=Substring:C12(aSalesReps{aSalesReps}; 1; 4)
	[Customers:16]SalesmanID:3:=Replace string:C233([Customers:16]SalesmanID:3; " "; "")
	RELATE ONE:C42([Customers:16]SalesmanID:3)
	[Customers:16]ModAddress:35:=4D_Current_date
	[Customers:16]ModFlag:37:=True:C214
	If ([Customers:16]SalesCoord:45="")
		[Customers:16]SalesCoord:45:=[Salesmen:32]Coordinator:14
	End if 
	//
	User_GiveAccess([Customers:16]SalesmanID:3; "Customers"; [Customers:16]ID:1; "RWD")
	
End if 
//