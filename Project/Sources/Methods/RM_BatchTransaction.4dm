//%attributes = {}
// Method: RM_BatchTransaction (rmcode;location"po";qty) -> 
// ----------------------------------------------------
// by: mel: 11/19/03, 09:32:10
// ----------------------------------------------------
// Description:
// record a batching component transaction
// ----------------------------------------------------

C_REAL:C285($3)
C_TEXT:C284($1; $2)

CREATE RECORD:C68([Raw_Materials_Transactions:23])  //*    Create an Batch "issue" transaction

[Raw_Materials_Transactions:23]CompanyID:20:=[Raw_Materials_Locations:25]CompanyID:27
[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=$1
[Raw_Materials_Transactions:23]Xfer_Type:2:="BATCH"  //10/28/94 made upper case
[Raw_Materials_Transactions:23]XferDate:3:=4D_Current_date
[Raw_Materials_Transactions:23]XferTime:25:=4d_Current_time
[Raw_Materials_Transactions:23]zCount:16:=1
[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
[Raw_Materials_Transactions:23]Commodity_Key:22:=[Raw_Materials_Locations:25]Commodity_Key:12
[Raw_Materials_Transactions:23]CommodityCode:24:=Num:C11(Substring:C12([Raw_Materials_Locations:25]Commodity_Key:12; 1; 2))
[Raw_Materials_Transactions:23]POItemKey:4:=[Raw_Materials_Locations:25]POItemKey:19
[Raw_Materials_Transactions:23]JobForm:12:="BATCH"
[Raw_Materials_Transactions:23]ReferenceNo:14:=[Raw_Materials:21]Raw_Matl_Code:1
[Raw_Materials_Transactions:23]ActCost:9:=[Raw_Materials_Locations:25]ActCost:18
[Raw_Materials_Transactions:23]viaLocation:11:=[Raw_Materials_Locations:25]Location:2
[Raw_Materials_Transactions:23]Location:15:=$2
[Raw_Materials_Transactions:23]Qty:6:=-$3
[Raw_Materials_Transactions:23]ActExtCost:10:=Round:C94(-$3*[Raw_Materials_Locations:25]ActCost:18; 2)
SAVE RECORD:C53([Raw_Materials_Transactions:23])