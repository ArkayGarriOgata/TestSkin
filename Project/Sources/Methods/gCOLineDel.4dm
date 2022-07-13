//%attributes = {"publishedWeb":true}
//gCOLineDel: Deletion for Customer Order file [OrderLines] 
//12/6/94 made more better : )

If ([Customers_Order_Lines:41]Status:9="Open@")
	//SEARCH([OrderChgHistory];[OrderChgHistory]OrderChg_Items=[OrderLines]OrderLine)
	$ordLine:=[Customers_Order_Lines:41]OrderLine:3
	$ord:=[Customers_Order_Lines:41]OrderNumber:1
	gDeleteRecord(->[Customers_Order_Lines:41])
	
	If ((fDelete) & (Not:C34(fCnclTrn)))
		
		QUERY:C277([Customers_Order_Change_Orders:34]; [Customers_Order_Change_Orders:34]OrderNo:5=$ord)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=$ordLine)
		If (Records in selection:C76([Customers_Order_Change_Orders:34])>0)
			DELETE SELECTION:C66([Customers_Order_Change_Orders:34])
		End if 
		
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			DELETE SELECTION:C66([Customers_ReleaseSchedules:46])
		End if 
		
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1)
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Order line must be in 'Open' status to delete.")
End if 