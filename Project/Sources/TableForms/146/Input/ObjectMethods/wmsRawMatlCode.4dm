READ ONLY:C145([Raw_Materials:21])
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[WMS_WarehouseOrders:146]RawMatlCode:2)  //RM_doesExist
If (Records in selection:C76([Raw_Materials:21])=1)
	ARRAY LONGINT:C221(aRecNum; 0)
	ARRAY TEXT:C222(asPoNo; 0)
	ARRAY TEXT:C222(asBin; 0)
	ARRAY REAL:C219(aQtyAvl; 0)
	ARRAY REAL:C219(aOrdQty; 0)
	
	READ ONLY:C145([Raw_Materials_Locations:25])
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[WMS_WarehouseOrders:146]RawMatlCode:2)
	$numBins:=Records in selection:C76([Raw_Materials_Locations:25])
	If ($numBins>0)
		ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19; >; [Raw_Materials_Locations:25]Location:2; >)
		SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]; aRecNum; [Raw_Materials_Locations:25]POItemKey:19; asPoNo; [Raw_Materials_Locations:25]Location:2; asBin; [Raw_Materials_Locations:25]QtyOH:9; aQtyAvl)
		ARRAY REAL:C219(aOrdQty; $numBins)
	End if 
	
Else 
	uConfirm([WMS_WarehouseOrders:146]RawMatlCode:2+" was not found."; "Try again"; "Help")
	[WMS_WarehouseOrders:146]RawMatlCode:2:=""
	GOTO OBJECT:C206([WMS_WarehouseOrders:146]RawMatlCode:2)
End if 
REDUCE SELECTION:C351([Raw_Materials:21]; 0)
REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)