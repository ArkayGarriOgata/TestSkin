//%attributes = {"publishedWeb":true}
//RM_BinCreate: Create [RM_BIN]
//3/27/95
//•1/2/97-cs- modification due to upr 0235
// charge code is now handled in 3 parts and this info need to be inserted into 
// these records
//•5/02/00  mlb  created date for Bin
//$1 - index into array
//$2 (optional) string charge code  -- upr 0235
//• mlb - 2/5/03  16:44 handle consignments

C_LONGINT:C283($1; $index)

$Index:=$1

CREATE RECORD:C68([Raw_Materials_Locations:25])
[Raw_Materials_Locations:25]Raw_Matl_Code:1:=aRMCode{$Index}
[Raw_Materials_Locations:25]Location:2:=aRMBinNo{$Index}
[Raw_Materials_Locations:25]BinCreated:4:=4D_Current_date  //•5/02/00  mlb 
[Raw_Materials_Locations:25]CompanyID:27:=ChrgCodeFrmLoc(aRMBinNo{$Index})

[Raw_Materials_Locations:25]POItemKey:19:=aRMPONum{$Index}+aRMPOItem{$Index}
If (Not:C34([Purchase_Orders_Items:12]Consignment:49))
	[Raw_Materials_Locations:25]QtyOH:9:=aRMSTKQty{$Index}
	[Raw_Materials_Locations:25]QtyAvailable:13:=aRMSTKQty{$Index}
	[Raw_Materials_Locations:25]ConsignmentQty:26:=0
Else 
	[Raw_Materials_Locations:25]ConsignmentQty:26:=aRMSTKQty{$Index}
	[Raw_Materials_Locations:25]QtyOH:9:=0
	[Raw_Materials_Locations:25]QtyAvailable:13:=0
End if 
[Raw_Materials_Locations:25]ActCost:18:=uNANCheck(aRMStdPrice{$Index})
[Raw_Materials_Locations:25]zCount:20:=1
[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
[Raw_Materials_Locations:25]ModWho:22:=<>zResp
[Raw_Materials_Locations:25]Commodity_Key:12:=[Raw_Materials:21]Commodity_Key:2  //3/27/95
SAVE RECORD:C53([Raw_Materials_Locations:25])
UNLOAD RECORD:C212([Raw_Materials_Locations:25])