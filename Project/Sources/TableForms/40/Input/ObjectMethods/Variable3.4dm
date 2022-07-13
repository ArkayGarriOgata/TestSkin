If (aSalesReps#0)  // & (Old(SalesmanID)="")
	[Customers_Orders:40]SalesRep:13:=Substring:C12(aSalesReps{aSalesReps}; 1; 4)
	[Customers_Orders:40]SalesRep:13:=Replace string:C233([Customers_Orders:40]SalesRep:13; " "; "")
End if 
//