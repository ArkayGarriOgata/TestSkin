//%attributes = {"publishedWeb":true}
//PM: RM_MillProductionPost() -> 
//@author mlb - 7/9/02  13:55
//init vars: dDate,rReal1,sCriterion4,sCriterion3

C_BOOLEAN:C305($0)
C_DATE:C307($today)

$0:=True:C214  //succeed presumption

If (Records in selection:C76([Purchase_Orders_Items:12])=1)
	$today:=4D_Current_date
	If (dDate=!00-00-00!)
		dDate:=$today
	End if 
	CREATE RECORD:C68([Raw_Materials_Transactions:23])
	[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
	[Raw_Materials_Transactions:23]Xfer_Type:2:="MILL"
	[Raw_Materials_Transactions:23]XferDate:3:=dDate
	[Raw_Materials_Transactions:23]POItemKey:4:=[Purchase_Orders_Items:12]POItemKey:1
	[Raw_Materials_Transactions:23]Reason:5:="Produced"
	[Raw_Materials_Transactions:23]Qty:6:=rReal1
	[Raw_Materials_Transactions:23]UnitPrice:7:=POIpriceToInvoice
	[Raw_Materials_Transactions:23]POQty:8:=0
	[Raw_Materials_Transactions:23]ActCost:9:=POIpriceToCost
	[Raw_Materials_Transactions:23]ActExtCost:10:=Round:C94([Raw_Materials_Transactions:23]Qty:6*[Raw_Materials_Transactions:23]ActCost:9; 2)
	[Raw_Materials_Transactions:23]viaLocation:11:="MILL"
	[Raw_Materials_Transactions:23]JobForm:12:=""
	[Raw_Materials_Transactions:23]Sequence:13:=0
	[Raw_Materials_Transactions:23]ReferenceNo:14:=sCriterion4
	[Raw_Materials_Transactions:23]Location:15:=sCriterion3
	[Raw_Materials_Transactions:23]zCount:16:=1
	[Raw_Materials_Transactions:23]ModDate:17:=$today
	[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
	[Raw_Materials_Transactions:23]CostCenter:19:=""
	[Raw_Materials_Transactions:23]CompanyID:20:=[Purchase_Orders_Items:12]CompanyID:45
	[Raw_Materials_Transactions:23]DepartmentID:21:=[Purchase_Orders_Items:12]DepartmentID:46
	[Raw_Materials_Transactions:23]Commodity_Key:22:=[Purchase_Orders_Items:12]Commodity_Key:26
	[Raw_Materials_Transactions:23]ReceivingNum:23:=0
	[Raw_Materials_Transactions:23]CommodityCode:24:=[Purchase_Orders_Items:12]CommodityCode:16
	[Raw_Materials_Transactions:23]XferTime:25:=4d_Current_time
	[Raw_Materials_Transactions:23]ExpenseCode:26:=[Purchase_Orders_Items:12]ExpenseCode:47
	SAVE RECORD:C53([Raw_Materials_Transactions:23])
	
	If (Records in selection:C76([Raw_Materials_Locations:25])=0)
		CREATE RECORD:C68([Raw_Materials_Locations:25])
		[Raw_Materials_Locations:25]Raw_Matl_Code:1:=[Raw_Materials_Transactions:23]Raw_Matl_Code:1
		[Raw_Materials_Locations:25]Location:2:=[Raw_Materials_Transactions:23]Location:15
		[Raw_Materials_Locations:25]POItemKey:19:=[Raw_Materials_Transactions:23]POItemKey:4
		[Raw_Materials_Locations:25]BinCreated:4:=$today
		[Raw_Materials_Locations:25]Commodity_Key:12:=[Raw_Materials_Transactions:23]Commodity_Key:22
		[Raw_Materials_Locations:25]zCount:20:=1
		[Raw_Materials_Locations:25]CompanyID:27:=[Raw_Materials_Transactions:23]CompanyID:20
	End if 
	
	[Raw_Materials_Locations:25]ActCost:18:=[Raw_Materials_Transactions:23]ActCost:9
	[Raw_Materials_Locations:25]MillNumber:25:=[Raw_Materials_Transactions:23]ReferenceNo:14
	[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9+[Raw_Materials_Transactions:23]Qty:6
	[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyOH:9
	[Raw_Materials_Locations:25]ModDate:21:=$today
	[Raw_Materials_Locations:25]ModWho:22:=<>zResp
	SAVE RECORD:C53([Raw_Materials_Locations:25])
	
Else 
	BEEP:C151
	zwStatusMsg("RM_MillProductionPost"; "Enter a valid PO item.")
	$0:=False:C215
End if 

REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
REDUCE SELECTION:C351([Purchase_Orders:11]; 0)
REDUCE SELECTION:C351([Vendors:7]; 0)
REDUCE SELECTION:C351([Raw_Materials_Groups:22]; 0)
REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)