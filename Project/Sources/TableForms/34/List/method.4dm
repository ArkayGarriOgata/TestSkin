app_basic_list_form_method
If (Form event code:C388=On Display Detail:K2:22)
	If ([Customers_Orders:40]OrderNumber:1#[Customers_Order_Change_Orders:34]OrderNo:5)
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Customers_Order_Change_Orders:34]OrderNo:5)
	End if 
End if 