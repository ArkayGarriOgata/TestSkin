//%attributes = {}
// -------
// Method: RM_BinCreateNegative   ( ) ->
// By: Mel Bohince @ 08/31/18, 12:09:01
// Description
// this is for the condition when they issue roll stock before it is received, who'd of guessed
// see also RM_BinCreate
// Modified by: Mel Bohince (1/14/20) must be have valid rm transaction record loaded
// ----------------------------------------------------


$qtyIssued:=[Raw_Materials_Transactions:23]Qty:6*-1  //flip the issue


CREATE RECORD:C68([Raw_Materials_Locations:25])
[Raw_Materials_Locations:25]Raw_Matl_Code:1:=[Raw_Materials_Transactions:23]Raw_Matl_Code:1
[Raw_Materials_Locations:25]Location:2:=[Raw_Materials_Transactions:23]viaLocation:11
[Raw_Materials_Locations:25]BinCreated:4:=4D_Current_date  //•5/02/00  mlb 
[Raw_Materials_Locations:25]CompanyID:27:="2"  //ChrgCodeFrmLoc (aRMBinNo{$Index})
[Raw_Materials_Locations:25]POItemKey:19:=[Raw_Materials_Transactions:23]POItemKey:4

//these should make negatives
[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9-$qtyIssued
[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyAvailable:13-$qtyIssued
[Raw_Materials_Locations:25]QtyCommitted:11:=[Raw_Materials_Locations:25]QtyCommitted:11-$qtyIssued
[Raw_Materials_Locations:25]ConsignmentQty:26:=0

[Raw_Materials_Locations:25]ActCost:18:=[Raw_Materials_Transactions:23]ActCost:9
[Raw_Materials_Locations:25]zCount:20:=1
[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
[Raw_Materials_Locations:25]ModWho:22:="aMs-"
[Raw_Materials_Locations:25]Commodity_Key:12:=[Raw_Materials_Transactions:23]Commodity_Key:22
SAVE RECORD:C53([Raw_Materials_Locations:25])
UNLOAD RECORD:C212([Raw_Materials_Locations:25])

