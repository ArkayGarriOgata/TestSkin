$tabNumber:=Selected list items:C379(iPSTabs)
GET LIST ITEM:C378(iPSTabs; $tabNumber; $itemRef; $itemText)

If ($itemText="Corrugate")
	READ ONLY:C145([Raw_Materials_Locations:25])
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=RMcode)
	If (Records in selection:C76([Raw_Materials_Locations:25])>0)
		iOnHand:=Sum:C1([Raw_Materials_Locations:25]QtyOH:9)
	Else 
		iOnHand:=0
	End if 
	
	READ ONLY:C145([Purchase_Orders_Items:12])
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Raw_Matl_Code:15=RMcode; *)
	QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]Qty_Open:27>0)
	If (Records in selection:C76([Purchase_Orders_Items:12])>0)
		iOnOrder:=Sum:C1([Purchase_Orders_Items:12]Qty_Open:27)
	Else 
		iOnOrder:=0
	End if 
	
	READ ONLY:C145([WMS_WarehouseOrders:146])
	QUERY:C277([WMS_WarehouseOrders:146]; [WMS_WarehouseOrders:146]RawMatlCode:2=RMcode; *)
	QUERY:C277([WMS_WarehouseOrders:146];  & ; [WMS_WarehouseOrders:146]Delivered:6=!00-00-00!)
	If (Records in selection:C76([WMS_WarehouseOrders:146])>0)
		iAllocated:=Sum:C1([WMS_WarehouseOrders:146]Qty:3)
	Else 
		iAllocated:=0
	End if 
	
	iOpen:=iOnHand-iAllocated
	
	QUERY:C277([WMS_WarehouseOrders:146]; [WMS_WarehouseOrders:146]RawMatlCode:2=RMcode; *)
	QUERY:C277([WMS_WarehouseOrders:146];  & ; [WMS_WarehouseOrders:146]JobReference:4=sJobit)
	
	ORDER BY:C49([WMS_WarehouseOrders:146]; [WMS_WarehouseOrders:146]QtyDelivered:8; >; [WMS_WarehouseOrders:146]Needed:5; <)
End if 