// -------
// Method: [Raw_Materials_Transactions].Issue_Dialog.Roll_id   ( ) ->
// By: Mel Bohince 
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (3/10/18) transition to [Raw_Material_Labels] table
// Modified by: Mel Bohince (3/29/18) calc ext cost
// Modified by: Mel Bohince (1/14/20) base location on RM_Location rec, not RM_Label rec
// Modified by: Mel Bohince (11/5/20) dont leave viaLocation blank if po not receive yet, default to Roanoke
//024367501
// Modified by: Mel Bohince (11/16/21) only consider the Roanoke (plant) warehouse , if at Vista it should have been Moved with the Move btn on the rm palette

REDUCE SELECTION:C351([Raw_Material_Labels:171]; 0)

//QUERY([Raw_Material_Labels];[Raw_Material_Labels]Label_id=tRoll_id)
//If (Records in selection([Raw_Material_Labels])=1)
//[Raw_Materials_Transactions]POItemKey:=[Raw_Material_Labels]POItemKey
//[Raw_Materials_Transactions]RM_Label_Id:=tRoll_id
//  //[Raw_Materials_Transactions]viaLocation:=[Raw_Material_Labels]Location
//[Raw_Materials_Transactions]Qty:=[Raw_Material_Labels]Qty
//End if 

C_OBJECT:C1216($entSel)
$entSel:=ds:C1482.Raw_Material_Labels.query("Label_id = :1"; tRoll_id)
If ($entSel.length>0)
	[Raw_Materials_Transactions:23]POItemKey:4:=$entSel.first().POItemKey
	[Raw_Materials_Transactions:23]RM_Label_Id:34:=tRoll_id
	[Raw_Materials_Transactions:23]Qty:6:=$entSel.first().Qty
Else 
	[Raw_Materials_Transactions:23]POItemKey:4:=""
End if 



If (Length:C16([Raw_Materials_Transactions:23]POItemKey:4)>0)
	
	// Modified by: Mel Bohince (1/14/20)
	// Modified by: Mel Bohince (11/16/21) only consider the Roanoke (plant) warehouse 
	$entSel:=ds:C1482.Raw_Materials_Locations.query("POItemKey = :1 and Location = :2"; [Raw_Materials_Transactions:23]POItemKey:4; "Roanoke")
	If ($entSel.length>0)
		[Raw_Materials_Transactions:23]viaLocation:11:=$entSel.first().Location
		[Raw_Materials_Transactions:23]ActCost:9:=$entSel.first().ActCost
	Else 
		[Raw_Materials_Transactions:23]viaLocation:11:="Roanoke"  // Modified by: Mel Bohince (11/5/20) was blank
	End if 
	
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
		[Raw_Materials_Transactions:23]ActExtCost:10:=Round:C94(([Raw_Materials_Transactions:23]ActCost:9*[Raw_Materials_Transactions:23]Qty:6); 2)  // Modified by: Mel Bohince (3/29/18) 
		
		If ([Purchase_Orders_Items:12]Consignment:49)  //• mlb - 2/5/03  16:57
			[Raw_Materials_Transactions:23]consignment:27:=True:C214
		Else 
			[Raw_Materials_Transactions:23]consignment:27:=False:C215
		End if 
	End if 
	
	
	
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]Qty:6)
	
Else 
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]POItemKey:4)
End if 