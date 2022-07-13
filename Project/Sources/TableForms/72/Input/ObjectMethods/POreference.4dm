QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=[Purchase_Order_TradeIns:72]POreference:4)
If (Records in selection:C76([Purchase_Orders_Items:12])=1)
	[Purchase_Order_TradeIns:72]Raw_Matl_Code:5:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
	[Purchase_Order_TradeIns:72]UOM:7:=[Purchase_Orders_Items:12]UM_Ship:5
	[Purchase_Order_TradeIns:72]VendorId:1:=[Purchase_Orders_Items:12]VendorID:39
	READ ONLY:C145([Vendors:7])
	QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Purchase_Order_TradeIns:72]VendorId:1)
	If (Records in selection:C76([Vendors:7])>0)
		[Purchase_Order_TradeIns:72]VendorName:2:=[Vendors:7]Name:2
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("PO_Item "+[Purchase_Order_TradeIns:72]POreference:4+" was not found, please enter the details.")
End if 
//