//how do you tell if a record is selected?

If (Records in set:C195("clickedIncludeRecord")>0)
	CUT NAMED SELECTION:C334([Customers_Order_Lines:41]; "hold")
	USE SET:C118("clickedIncludeRecord")
	
	uConfirm("Are you sure you want to delete item "+String:C10([Customers_Order_Lines:41]LineItem:2; "000")+"?"; "Delete"; "Cancel")
	If (OK=1)
		DELETE RECORD:C58([Customers_Order_Lines:41])
		i1:=i1-1
		
		fItemChg:=True:C214
		//reselect ordderlines
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1)
		If (fItemChg)
			rReal1:=fTotalOrderLine
		End if 
		ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3; >)
	End if 
	
Else 
	uConfirm("You Must Select a Line Item first."; "OK"; "Help")
End if 