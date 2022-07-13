If ([WMS_WarehouseOrders:146]JobReference:4#"Roanoke")
	READ ONLY:C145([Job_Forms:42])
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[WMS_WarehouseOrders:146]JobReference:4)
	If (Records in selection:C76([Job_Forms:42])#1)
		uConfirm([WMS_WarehouseOrders:146]JobReference:4+" was not found."; "Try again"; "Help")
		[WMS_WarehouseOrders:146]JobReference:4:=""
		GOTO OBJECT:C206([WMS_WarehouseOrders:146]JobReference:4)
	End if 
End if 