$selected_item:=Num:C11(Request:C163("Which item number?"; "0"; "Delete"; "Cancel"))
If (ok=1)
	If ($selected_item#0)
		CUT NAMED SELECTION:C334([Customers_Order_Changed_Items:176]; "before_delete")
		QUERY:C277([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]id_added_by_converter:41=[Customers_Order_Change_Orders:34]OrderChg_Items:6; *)
		QUERY:C277([Customers_Order_Changed_Items:176];  & ; [Customers_Order_Changed_Items:176]ItemNo:1=$selected_item)
		
		If (Records in selection:C76([Customers_Order_Changed_Items:176])=1)
			uConfirm("Delete Item # "+String:C10([Customers_Order_Changed_Items:176]ItemNo:1)+" "+[Customers_Order_Changed_Items:176]NewProductCode:10+"?"; "Delete"; "Cancel")
			If (ok=1)
				DELETE RECORD:C58([Customers_Order_Changed_Items:176])
				
				RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
				ORDER BY:C49([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]ItemNo:1; >)
			End if 
			
		Else 
			uConfirm("Item "+String:C10($selected_item)+" not found."; "OK"; "Help")
			USE NAMED SELECTION:C332("before_delete")
		End if 
		
	Else 
		uConfirm("Enter an item number to delete."; "OK"; "Help")
	End if 
	
End if 