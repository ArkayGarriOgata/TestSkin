//(S) [CustomerOrder]Input'AccPrpChrg
uConfirm("Create a Change Order for Order Nº "+String:C10([Customers_Orders:40]OrderNumber:1; "00000")+"?"; "Create"; "Cancel")

If (OK=1)
	
	OBJECT SET ENABLED:C1123(EditCO; True:C214)
	fLoop:=True:C214
	gNewCustOrdCO
	fLoop:=False:C215
	QUERY:C277([Customers_Order_Change_Orders:34]; [Customers_Order_Change_Orders:34]OrderNo:5=[Customers_Orders:40]OrderNumber:1)
	ORDER BY:C49([Customers_Order_Change_Orders:34]; [Customers_Order_Change_Orders:34]ChangeOrderNumb:1; <)
	RELATE MANY:C262([Customers_Orders:40]OrderNumber:1)
	ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3; >)
	
End if 

Invoice_SetInvoiceBtnState
//EOS