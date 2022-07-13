//%attributes = {"publishedWeb":true}
//PM:  PI_POfromRMmCode;poItemKey;issueUOM)  3/30/00  mlb
//create a po from an RawMaterial record

$rmCode:=$1
$poItemKey:=$2
$costPerUnit:=$3
$0:=False:C215

QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=$rmCode)
If (Records in selection:C76([Raw_Materials:21])>0)
	$0:=True:C214
	CREATE RECORD:C68([Purchase_Orders_Items:12])
	If (False:C215)  //too much extra crap
		POI_makeLikeRM
	End if 
	[Purchase_Orders_Items:12]POItemKey:1:=$poItemKey
	[Purchase_Orders_Items:12]PONo:2:=Substring:C12($poItemKey; 1; 6)
	[Purchase_Orders_Items:12]ItemNo:3:=Substring:C12($poItemKey; 8; 2)
	[Purchase_Orders_Items:12]VendorID:39:="00001"
	[Purchase_Orders_Items:12]UM_Arkay_Issue:28:=[Raw_Materials:21]IssueUOM:10
	[Purchase_Orders_Items:12]Raw_Matl_Code:15:=$rmCode
	[Purchase_Orders_Items:12]CommodityCode:16:=[Raw_Materials:21]CommodityCode:26
	[Purchase_Orders_Items:12]SubGroup:13:=[Raw_Materials:21]SubGroup:31
	[Purchase_Orders_Items:12]Commodity_Key:26:=[Raw_Materials:21]Commodity_Key:2
	[Purchase_Orders_Items:12]CompanyID:45:=[Raw_Materials:21]CompanyID:27
	[Purchase_Orders_Items:12]DepartmentID:46:=[Raw_Materials:21]DepartmentID:28
	[Purchase_Orders_Items:12]ExpenseCode:47:=[Raw_Materials:21]Obsolete_ExpCode:29
	[Purchase_Orders_Items:12]RM_Description:7:=[Raw_Materials:21]Description:4
	[Purchase_Orders_Items:12]VendPartNo:6:=$rmCode
	[Purchase_Orders_Items:12]UnitPrice:10:=$costPerUnit
	[Purchase_Orders_Items:12]UM_Ship:5:=[Raw_Materials:21]ReceiptUOM:9
	[Purchase_Orders_Items:12]FactNship2cost:29:=[Raw_Materials:21]ConvertRatio_N:16
	[Purchase_Orders_Items:12]FactDship2cost:37:=[Raw_Materials:21]ConvertRatio_D:17
	[Purchase_Orders_Items:12]Flex1:31:=[Raw_Materials:21]Flex1:19
	[Purchase_Orders_Items:12]Flex2:32:=[Raw_Materials:21]Flex2:20
	[Purchase_Orders_Items:12]Flex3:33:=[Raw_Materials:21]Flex3:21
	[Purchase_Orders_Items:12]Flex4:34:=[Raw_Materials:21]Flex4:22
	[Purchase_Orders_Items:12]Flex5:35:=[Raw_Materials:21]Flex5:23
	[Purchase_Orders_Items:12]Flex6:36:=[Raw_Materials:21]Flex6:24
	SAVE RECORD:C53([Purchase_Orders_Items:12])
	
Else 
	BEEP:C151
	ALERT:C41($rmCode+" is not in item master, create the RM code, then try again.")
End if   //found rm