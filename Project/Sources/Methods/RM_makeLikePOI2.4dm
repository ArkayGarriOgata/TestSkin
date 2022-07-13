//%attributes = {"publishedWeb":true}

// Method: RM_makeLikePOI2 ( )  -> 
// ----------------------------------------------------

//uPO2RM2  based on uPO2RM
//•5/06/99  MLB 
//same but execute on server

C_BOOLEAN:C305($continue)  //•092595  MLB  UPr 1707
C_TEXT:C284($1; $poiKey)
C_REAL:C285($2)

$poiKey:=$1
//DELAY PROCESS(Current process;120)  `give poi time to save?
//READ ONLY([PO_Items])
//QUERY([PO_Items];[PO_Items]POItemKey=$poiKey)
//If (Records in selection([PO_Items])>0)

READ WRITE:C146([Raw_Materials:21])
SET QUERY LIMIT:C395(1)
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15)
SET QUERY LIMIT:C395(0)
If (Records in selection:C76([Raw_Materials:21])=0)
	CREATE RECORD:C68([Raw_Materials:21])
	[Raw_Materials:21]NewFromReq:42:=False:C215
End if 

[Raw_Materials:21]Raw_Matl_Code:1:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
[Raw_Materials:21]CommodityCode:26:=[Purchase_Orders_Items:12]CommodityCode:16
[Raw_Materials:21]SubGroup:31:=[Purchase_Orders_Items:12]SubGroup:13
[Raw_Materials:21]Commodity_Key:2:=[Purchase_Orders_Items:12]Commodity_Key:26

//Upr 0235
//  [RAW_MATERIALS]ChargeCode:=[PO_ITEMS]ChargeCode
If ([Raw_Materials:21]CompanyID:27="")
	[Raw_Materials:21]CompanyID:27:=[Purchase_Orders_Items:12]CompanyID:45
End if 
If ([Raw_Materials:21]DepartmentID:28="")
	[Raw_Materials:21]DepartmentID:28:=[Purchase_Orders_Items:12]DepartmentID:46
End if 
If ([Raw_Materials:21]Obsolete_ExpCode:29="")
	[Raw_Materials:21]Obsolete_ExpCode:29:=[Purchase_Orders_Items:12]ExpenseCode:47
End if 
//end Upr 0235

[Raw_Materials:21]Description:4:=[Purchase_Orders_Items:12]RM_Description:7
[Raw_Materials:21]ReceiptUOM:9:=[Purchase_Orders_Items:12]UM_Ship:5
[Raw_Materials:21]IssueUOM:10:=[Purchase_Orders_Items:12]UM_Arkay_Issue:28
[Raw_Materials:21]ConvertRatio_N:16:=[Purchase_Orders_Items:12]FactNship2cost:29
[Raw_Materials:21]ConvertRatio_D:17:=[Purchase_Orders_Items:12]FactDship2cost:37  //•082295  MLB  UPR 1707
// Modified by: Mel Bohince (4/10/17) 
[Raw_Materials:21]ConvertPrice_N:35:=[Purchase_Orders_Items:12]FactNship2price:25
[Raw_Materials:21]ConvertPrice_D:36:=[Purchase_Orders_Items:12]FactDship2price:38

[Raw_Materials:21]LastPurCost:43:=[Purchase_Orders_Items:12]UnitPrice:10
[Raw_Materials:21]LastPurDate:44:=4D_Current_date
[Raw_Materials:21]ActCost:45:=$2  //[PO_Items]UnitPrice*([PO_Items]FactNship2price/[PO_Items]FactDship2price)
[Raw_Materials:21]Flex1:19:=[Purchase_Orders_Items:12]Flex1:31
[Raw_Materials:21]Flex2:20:=[Purchase_Orders_Items:12]Flex2:32
[Raw_Materials:21]Flex3:21:=[Purchase_Orders_Items:12]Flex3:33
[Raw_Materials:21]Flex4:22:=[Purchase_Orders_Items:12]Flex4:34
[Raw_Materials:21]Flex5:23:=[Purchase_Orders_Items:12]Flex5:35
[Raw_Materials:21]Flex6:24:=[Purchase_Orders_Items:12]Flex6:36
SAVE RECORD:C53([Raw_Materials:21])

QUERY:C277([Raw_Materials_Suggest_Vendors:173]; [Raw_Materials_Suggest_Vendors:173]VendorID:1=[Purchase_Orders_Items:12]VendorID:39; *)
QUERY:C277([Raw_Materials_Suggest_Vendors:173];  & ; [Raw_Materials_Suggest_Vendors:173]VendorPartNumber:3=[Purchase_Orders_Items:12]VendPartNo:6)
If (Records in selection:C76([Raw_Materials_Suggest_Vendors:173])=0)
	CREATE RECORD:C68([Raw_Materials_Suggest_Vendors:173])
	READ ONLY:C145([Vendors:7])
	RELATE ONE:C42([Purchase_Orders_Items:12]VendorID:39)
	[Raw_Materials_Suggest_Vendors:173]VendorID:1:=[Purchase_Orders_Items:12]VendorID:39
	[Raw_Materials_Suggest_Vendors:173]Name:4:=[Vendors:7]Name:2
	[Raw_Materials_Suggest_Vendors:173]id_added_by_converter:9:=[Raw_Materials:21]Suggest_Vendors:49
End if 
[Raw_Materials_Suggest_Vendors:173]VendorPartNumber:3:=[Purchase_Orders_Items:12]VendPartNo:6
[Raw_Materials_Suggest_Vendors:173]Raw_Matl_Code:2:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
[Raw_Materials_Suggest_Vendors:173]FactNShip2price:7:=[Purchase_Orders_Items:12]FactNship2price:25
[Raw_Materials_Suggest_Vendors:173]FactDship2price:8:=[Purchase_Orders_Items:12]FactDship2price:38
[Raw_Materials_Suggest_Vendors:173]UMprice:6:=[Purchase_Orders_Items:12]UM_Price:24
SAVE RECORD:C53([Raw_Materials_Suggest_Vendors:173])
UNLOAD RECORD:C212([Raw_Materials_Suggest_Vendors:173])
UNLOAD RECORD:C212([Raw_Materials:21])