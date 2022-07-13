//(S) [CustomerOrder]Input'AccPrpChrg

If (Records in set:C195("clickedIncludeRecordCO")>0)
	CUT NAMED SELECTION:C334([Customers_Order_Change_Orders:34]; "hold")
	CUT NAMED SELECTION:C334([Customers_Order_Lines:41]; "hold2")
	USE SET:C118("clickedIncludeRecordCO")
	
	fLoop:=True:C214
	MODIFY RECORD:C57([Customers_Order_Change_Orders:34]; *)
	fLoop:=False:C215
	USE NAMED SELECTION:C332("hold")
	USE NAMED SELECTION:C332("hold2")
	
	Invoice_SetInvoiceBtnState
	
Else 
	uConfirm("You Must Select a Change Order to Edit."; "OK"; "Help")
End if 