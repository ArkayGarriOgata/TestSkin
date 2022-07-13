//•060195  MLB  UPR 184
//• 7/8/97 cs upr 1846 - allow adjust -> close status change

C_TEXT:C284($oldStat)

$oldStat:=[Customers_Order_Lines:41]Status:9

If (util_PopUpDropDownAction(->asOrderLineStatus; ->[Customers_Order_Lines:41]Status:9))
	
	Case of 
		: ([Customers_Order_Lines:41]Status:9="Opened") & (Not:C34(User in group:C338(Current user:C182; "CustomerOrdering")))  //BAK 8/30/94 was "CO_Approval"
			[Customers_Order_Lines:41]Status:9:=$oldStat
			uConfirm("Must be in 'CustomerOrdering' to Open a Customer Orderline!"; "OK"; "Help")
			
		: ([Customers_Order_Lines:41]Status:9="Accepted") & (Not:C34(User in group:C338(Current user:C182; "CO_Approval")))
			[Customers_Order_Lines:41]Status:9:=$oldStat
			uConfirm("Must be in 'CO_Approval' to Accept a Customer Orderline!"; "OK"; "Help")
			
		: ([Customers_Order_Lines:41]Status:9="Rejected") & (Not:C34(User in group:C338(Current user:C182; "CO_Approval")))
			[Customers_Order_Lines:41]Status:9:=$oldStat
			uConfirm("Must be in 'CO_Approval' to Reject a Customer Orderline!"; "OK"; "Help")
			
		Else 
			ChgCOrderStatus($oldStat; 1)
	End case 
	
End if 