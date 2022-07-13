//%attributes = {}
// _______
// Method: RIM_ReconcileApplyChange   ( setQtyTo ) ->
// By: Mel Bohince @ 04/17/19, 09:46:09
// Description
// change the selected rm_location record based on the sum of the selected labels
// ----------------------------------------------------
C_BOOLEAN:C305($0)
C_LONGINT:C283($sumLabels; $1)
$sumLabels:=$1

READ ONLY:C145([Purchase_Orders_Items:12])
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=[Raw_Materials_Locations:25]POItemKey:19)

CREATE RECORD:C68([Raw_Materials_Transactions:23])
[Raw_Materials_Transactions:23]Xfer_Type:2:="ADJUST"
[Raw_Materials_Transactions:23]XferDate:3:=Current date:C33
[Raw_Materials_Transactions:23]Reason:5:="Label_Recon"

[Raw_Materials_Transactions:23]POItemKey:4:=[Raw_Materials_Locations:25]POItemKey:19
[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Raw_Materials_Locations:25]Raw_Matl_Code:1

[Raw_Materials_Transactions:23]Qty:6:=$sumLabels-[Raw_Materials_Locations:25]QtyOH:9
[Raw_Materials_Transactions:23]Location:15:=[Raw_Materials_Locations:25]Location:2
[Raw_Materials_Transactions:23]viaLocation:11:="Cycle Count"

[Raw_Materials_Transactions:23]Commodity_Key:22:=[Purchase_Orders_Items:12]Commodity_Key:26
[Raw_Materials_Transactions:23]CommodityCode:24:=[Purchase_Orders_Items:12]CommodityCode:16
[Raw_Materials_Transactions:23]UnitPrice:7:=[Purchase_Orders_Items:12]UnitPrice:10
[Raw_Materials_Transactions:23]ActCost:9:=POIpriceToCost  //uNANCheck ([PO_Items]UnitPrice*([PO_Items]FactNship2price/[PO_Items]FactDship2pr      
[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94([Raw_Materials_Transactions:23]Qty:6*[Raw_Materials_Transactions:23]ActCost:9; 2))


[Raw_Materials_Transactions:23]CompanyID:20:=[Purchase_Orders_Items:12]CompanyID:45
[Raw_Materials_Transactions:23]DepartmentID:21:=[Purchase_Orders_Items:12]DepartmentID:46
[Raw_Materials_Transactions:23]ExpenseCode:26:=[Purchase_Orders_Items:12]ExpenseCode:47

[Raw_Materials_Transactions:23]zCount:16:=1
[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
[Raw_Materials_Transactions:23]ModWho:18:=<>zResp

SAVE RECORD:C53([Raw_Materials_Transactions:23])
UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
UNLOAD RECORD:C212([Purchase_Orders_Items:12])

[Raw_Materials_Locations:25]LastCycleCount:7:=[Raw_Materials_Locations:25]QtyOH:9
[Raw_Materials_Locations:25]LastCycleDate:8:=Current date:C33
[Raw_Materials_Locations:25]QtyOH:9:=$sumLabels
[Raw_Materials_Locations:25]QtyAvailable:13:=$sumLabels
[Raw_Materials_Locations:25]ModDate:21:=Current date:C33
[Raw_Materials_Locations:25]ModWho:22:=<>zResp
SAVE RECORD:C53([Raw_Materials_Locations:25])
$0:=([Raw_Materials_Locations:25]QtyOH:9=$sumLabels)
zwStatusMsg([Raw_Materials_Locations:25]Raw_Matl_Code:1; " qty changed")
