If (Records in set:C195("clickedIncludeRecord")>0)
	CUT NAMED SELECTION:C334([Customers_Order_Lines:41]; "hold")
	USE SET:C118("clickedIncludeRecord")
	
	FORM SET INPUT:C55([Customers_Order_Lines:41]; "Input")
	MODIFY RECORD:C57([Customers_Order_Lines:41]; *)
	
	USE NAMED SELECTION:C332("hold")
	If (fItemChg)
		rReal1:=fTotalOrderLine
	End if 
	Invoice_SetInvoiceBtnState
	
Else 
	uConfirm("You Must Select a Line Item first."; "OK"; "Help")
End if 