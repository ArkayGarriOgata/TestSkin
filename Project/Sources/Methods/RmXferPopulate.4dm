//%attributes = {"publishedWeb":true}
//(p) RMXferPopulate
//moved duplicated code from Return to this procudure
//$1-String-companyID
//• 10/30/97 cs created

C_TEXT:C284($1)

[Raw_Materials_Transactions:23]Xfer_Type:2:="Return"
[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
[Raw_Materials_Transactions:23]viaLocation:11:=sCriterion3
[Raw_Materials_Transactions:23]Location:15:=sCriterion4
[Raw_Materials_Transactions:23]XferDate:3:=dDate
[Raw_Materials_Transactions:23]ReceivingNum:23:=Num:C11(sCriterion4)
[Raw_Materials_Transactions:23]POItemKey:4:=sCriterion2
[Raw_Materials_Transactions:23]CommodityCode:24:=[Raw_Materials_Groups:22]Commodity_Code:1
[Raw_Materials_Transactions:23]Commodity_Key:22:=[Raw_Materials_Groups:22]Commodity_Key:3
[Raw_Materials_Transactions:23]Qty:6:=-rReal1
[Raw_Materials_Transactions:23]POQty:8:=-rRealShippingUOM  // Modified by: Mel Bohince (5/4/17) 
[Raw_Materials_Transactions:23]UnitPrice:7:=[Purchase_Orders_Items:12]UnitPrice:10
[Raw_Materials_Transactions:23]ActCost:9:=POIpriceToCost
[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94(-rReal1*[Raw_Materials_Transactions:23]ActCost:9; 2))
[Raw_Materials_Transactions:23]zCount:16:=1
[Raw_Materials_Transactions:23]CompanyID:20:=$1  //•2/13/97 assign company based on bin
[Raw_Materials_Transactions:23]DepartmentID:21:=[Purchase_Orders_Items:12]DepartmentID:46
[Raw_Materials_Transactions:23]ExpenseCode:26:=[Purchase_Orders_Items:12]ExpenseCode:47
[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
[Raw_Materials_Transactions:23]ModWho:18:=<>zResp