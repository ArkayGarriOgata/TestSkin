//%attributes = {}
// ----------------------------------------------------
// Method: RM_PostReceiptNewBin   ( ) ->
// By: Mel Bohince @ 03/03/16, 15:31:22
// Description
// make an empty bin
// ----------------------------------------------------

CREATE RECORD:C68([Raw_Materials_Locations:25])
[Raw_Materials_Locations:25]Raw_Matl_Code:1:=[Raw_Materials_Transactions:23]Raw_Matl_Code:1
[Raw_Materials_Locations:25]Location:2:=[Raw_Materials_Transactions:23]Location:15
[Raw_Materials_Locations:25]BinCreated:4:=4D_Current_date  //•5/02/00  mlb 
[Raw_Materials_Locations:25]CompanyID:27:=[Raw_Materials_Transactions:23]CompanyID:20
[Raw_Materials_Locations:25]POItemKey:19:=[Raw_Materials_Transactions:23]POItemKey:4
[Raw_Materials_Locations:25]zCount:20:=1
[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
[Raw_Materials_Locations:25]ModWho:22:=<>zResp
[Raw_Materials_Locations:25]Commodity_Key:12:=[Raw_Materials:21]Commodity_Key:2
[Raw_Materials_Locations:25]QtyOH:9:=0
[Raw_Materials_Locations:25]QtyAvailable:13:=0
[Raw_Materials_Locations:25]QtyCommitted:11:=0
