If (Position:C15("New"; [Customers_Order_Change_Orders:34]ChgOrderStatus:20)=0) & ((User in group:C338(Current user:C182; "SalesReps")) | (User in group:C338(Current user:C182; "SalesCoordinator")))
	uConfirm("Warning: Change order is not in 'New' status. "; "OK"; "Help")
	
Else 
	CREATE RECORD:C68([Customers_Order_Changed_Items:176])
	[Customers_Order_Changed_Items:176]id_added_by_converter:41:=[Customers_Order_Change_Orders:34]OrderChg_Items:6
	SAVE RECORD:C53([Customers_Order_Changed_Items:176])
	//
	RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
	ORDER BY:C49([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]ItemNo:1; >)
	ALERT:C41("Enter 0 ITEM for pick list, enter unused number for new CPN or PREP.")
End if 