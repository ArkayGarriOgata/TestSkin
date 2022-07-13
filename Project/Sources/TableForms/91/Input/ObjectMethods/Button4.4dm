CONFIRM:C162("Submit a request for "+String:C10(iQty)+" of "+RMcode+"?"; "Yes"; "Cancel")
If (ok=1)
	CREATE RECORD:C68([WMS_WarehouseOrders:146])
	[WMS_WarehouseOrders:146]id:1:=app_AutoIncrement(->[WMS_WarehouseOrders:146])
	[WMS_WarehouseOrders:146]JobReference:4:=sJobit
	[WMS_WarehouseOrders:146]Needed:5:=dDateBegin
	[WMS_WarehouseOrders:146]Qty:3:=iQty
	[WMS_WarehouseOrders:146]RawMatlCode:2:=RMcode
	SAVE RECORD:C53([WMS_WarehouseOrders:146])
	UNLOAD RECORD:C212([WMS_WarehouseOrders:146])
	
	READ ONLY:C145([WMS_WarehouseOrders:146])
	QUERY:C277([WMS_WarehouseOrders:146]; [WMS_WarehouseOrders:146]RawMatlCode:2=RMcode; *)
	QUERY:C277([WMS_WarehouseOrders:146];  & ; [WMS_WarehouseOrders:146]Delivered:6=!00-00-00!)
	If (Records in selection:C76([WMS_WarehouseOrders:146])>0)
		iAllocated:=Sum:C1([WMS_WarehouseOrders:146]Qty:3)
	Else 
		iAllocated:=0
	End if 
	
	iOpen:=iOnHand-iAllocated
	
	QUERY:C277([WMS_WarehouseOrders:146]; [WMS_WarehouseOrders:146]RawMatlCode:2=RMcode)
	
	ORDER BY:C49([WMS_WarehouseOrders:146]; [WMS_WarehouseOrders:146]QtyDelivered:8; >; [WMS_WarehouseOrders:146]Needed:5; <)
	
Else 
	BEEP:C151
End if 
