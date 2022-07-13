//%attributes = {"publishedWeb":true}
//(p) PoCommCode
//moved code from commodity code script here ++
// SetObjectProperties, Mark Zinke (5/16/13)

RMG_buildSubgroupList([Purchase_Orders_Items:12]CommodityCode:16; ->aSubGroup)
[Purchase_Orders_Items:12]Commodity_Key:26:=RMG_getCommodityKey([Purchase_Orders_Items:12]CommodityCode:16; [Purchase_Orders_Items:12]SubGroup:13)
If (RMG_is_CommodityKey_Valid([Purchase_Orders_Items:12]Commodity_Key:26))
	iComm:=[Purchase_Orders_Items:12]CommodityCode:16
	fNewRM:=True:C214
	If (Length:C16([Purchase_Orders_Items:12]DepartmentID:46)<4)
		[Purchase_Orders_Items:12]DepartmentID:46:=RMG_getDepartmentCode([Purchase_Orders_Items:12]Commodity_Key:26)
	End if 
	[Purchase_Orders_Items:12]ExpenseCode:47:=RMG_getExpenseCode([Purchase_Orders_Items:12]Commodity_Key:26)
	util_ComboBoxSetup(->aExpCode; [Purchase_Orders_Items:12]ExpenseCode:47)
	util_ComboBoxSetup(->aDepartment; [Purchase_Orders_Items:12]DepartmentID:46)
Else 
	iComm:=0
End if 

sRMflexFields([Purchase_Orders_Items:12]CommodityCode:16; 1)
sSetPurchaseUM([Purchase_Orders_Items:12]CommodityCode:16)

If ([Purchase_Orders_Items:12]CommodityCode:16<=13)
	If ([Purchase_Orders_Items:12]DepartmentID:46="") | ([Purchase_Orders_Items:12]DepartmentID:46="0000") | ([Purchase_Orders_Items:12]DepartmentID:46="____")
		[Purchase_Orders_Items:12]DepartmentID:46:="9999"
		util_ComboBoxSetup(->aDepartment; [Purchase_Orders_Items:12]DepartmentID:46)
	End if 
	SetObjectProperties("exp@"; -><>NULL; False:C215)
Else 
	SetObjectProperties("exp@"; -><>NULL; True:C214)
End if 

If ([Purchase_Orders_Items:12]CommodityCode:16=39)
	SetObjectProperties("asset@"; -><>NULL; True:C214; ""; True:C214)
	If (Length:C16([Purchase_Orders_Items:12]AssetNumber:50)=0)
		uConfirm("Asset number required, call Purchasing."; "OK"; "Help")
	End if 
End if 

//util_ComboBoxSetup (->aUOM1;[Purchase_Orders_Items]UM_Ship)
util_ComboBoxSetup(->aUOM2; [Purchase_Orders_Items:12]UM_Arkay_Issue:28)
//util_ComboBoxSetup (->aUOM3;[Purchase_Orders_Items]UM_Price)