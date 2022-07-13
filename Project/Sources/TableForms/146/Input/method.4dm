// ----------------------------------------------------
// Form Method: [WMS_WarehouseOrders].Input
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		If ([WMS_WarehouseOrders:146]id:1>0)
			SetObjectProperties("wms@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
			SetObjectProperties("Del@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
			<>pid_WMS_Order:=0
		Else 
			[WMS_WarehouseOrders:146]id:1:=app_AutoIncrement(->[WMS_WarehouseOrders:146])
			[WMS_WarehouseOrders:146]Needed:5:=4D_Current_date
			SetObjectProperties("wms@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/14/13)
			SetObjectProperties("Del@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
			SetObjectProperties(""; ->bAdd; True:C214; "Make your entries")  // Modified by: Mark Zinke (5/14/13)
			OBJECT SET ENABLED:C1123(bAdd; False:C215)
			//◊pid_WMS_Order was set on the List form's New button
		End if 
		
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
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		
	: (Form event code:C388=On Validate:K2:3)
		Case of   //certain types of changes
			: ([WMS_WarehouseOrders:146]RawMatlCode:2#Old:C35([WMS_WarehouseOrders:146]RawMatlCode:2))
				[WMS_WarehouseOrders:146]ModDate:13:=4D_Current_date
				[WMS_WarehouseOrders:146]ModWho:12:=<>zResp
			: ([WMS_WarehouseOrders:146]Qty:3#Old:C35([WMS_WarehouseOrders:146]Qty:3))
				[WMS_WarehouseOrders:146]ModDate:13:=4D_Current_date
				[WMS_WarehouseOrders:146]ModWho:12:=<>zResp
			: ([WMS_WarehouseOrders:146]JobReference:4#Old:C35([WMS_WarehouseOrders:146]JobReference:4))
				[WMS_WarehouseOrders:146]ModDate:13:=4D_Current_date
				[WMS_WarehouseOrders:146]ModWho:12:=<>zResp
			: ([WMS_WarehouseOrders:146]Needed:5#Old:C35([WMS_WarehouseOrders:146]Needed:5))
				[WMS_WarehouseOrders:146]ModDate:13:=4D_Current_date
				[WMS_WarehouseOrders:146]ModWho:12:=<>zResp
		End case 
		
		If (<>pid_WMS_Order#0)
			POST OUTSIDE CALL:C329(<>pid_WMS_Order)
			<>pid_WMS_Order:=0
		End if 
End case 