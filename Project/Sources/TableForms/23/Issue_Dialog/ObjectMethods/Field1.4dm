// _______
// Method: [Raw_Materials_Transactions].Issue_Dialog.POItemKey  ( ) ->

// Modified by: Mel Bohince (1/14/20) orda the location query, don't want to lock said record

tText:=""
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=[Raw_Materials_Transactions:23]POItemKey:4)
If (Records in selection:C76([Purchase_Orders_Items:12])=0)
	tText:=[Raw_Materials_Transactions:23]POItemKey:4+" was not found."
	uConfirm(tText; "Ok"; "Help")
	[Raw_Materials_Transactions:23]POItemKey:4:=""
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]POItemKey:4)
Else 
	[Raw_Materials_Transactions:23]Commodity_Key:22:=[Purchase_Orders_Items:12]Commodity_Key:26
	[Raw_Materials_Transactions:23]CommodityCode:24:=[Purchase_Orders_Items:12]CommodityCode:16
	[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
	
	[Raw_Materials_Transactions:23]CompanyID:20:=[Purchase_Orders_Items:12]CompanyID:45
	[Raw_Materials_Transactions:23]DepartmentID:21:=[Purchase_Orders_Items:12]DepartmentID:46
	[Raw_Materials_Transactions:23]ExpenseCode:26:=[Purchase_Orders_Items:12]ExpenseCode:47
	[Raw_Materials_Transactions:23]ActCost:9:=POIpriceToCost
	
	If ([Purchase_Orders_Items:12]Consignment:49)  //• mlb - 2/5/03  16:57
		[Raw_Materials_Transactions:23]consignment:27:=True:C214
	Else 
		[Raw_Materials_Transactions:23]consignment:27:=False:C215
	End if 
	
	
	// Modified by: Mel Bohince (1/14/20) 
	C_OBJECT:C1216($entSel)
	$entSel:=ds:C1482.Raw_Materials_Locations.query("POItemKey = :1"; [Raw_Materials_Transactions:23]POItemKey:4)
	If ($entSel.length>0)
		[Raw_Materials_Transactions:23]viaLocation:11:=$entSel.first().Location
		[Raw_Materials_Transactions:23]ActCost:9:=$entSel.first().ActCost
	Else 
		[Raw_Materials_Transactions:23]viaLocation:11:=""
	End if 
	
	//QUERY([Raw_Materials_Locations];[Raw_Materials_Locations]POItemKey=[Raw_Materials_Transactions]POItemKey)
	//If (Records in selection([Raw_Materials_Locations])=1)
	//[Raw_Materials_Transactions]viaLocation:=[Raw_Materials_Locations]Location
	//[Raw_Materials_Transactions]ActCost:=[Raw_Materials_Locations]ActCost
	//GOTO OBJECT([Raw_Materials_Transactions]Qty)
	
	//Else 
	//SELECTION TO ARRAY([Raw_Materials_Locations]Location;$aLocations)
	//$msg:="Pick from: "
	//C_LONGINT($i)
	//For ($i;1;Size of array($aLocations))
	//$msg:=$msg+$aLocations{$i}+Char(13)  //", "
	//End for 
	//  //zwStatusMsg ("HINT";$msg)
	//tText:=$msg
	//  //
	//  //uConfirm ("That PO in multiple locations, pick one.";"Ok";"Help")
	//  //[Raw_Materials_Transactions]viaLocation:=$aLocations{1}
	//GOTO OBJECT([Raw_Materials_Transactions]viaLocation)
	//End if 
End if 