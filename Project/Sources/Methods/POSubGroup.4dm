//%attributes = {"publishedWeb":true}
//(p) POSubGroup
//moved code from script to here, called from popup too
//• 7/2/97 cs created
//• 9/4/97 cs changed from stripping spaces to cap&strip

txt_CapNstrip(->[Purchase_Orders_Items:12]SubGroup:13)
[Purchase_Orders_Items:12]Commodity_Key:26:=RMG_getCommodityKey([Purchase_Orders_Items:12]CommodityCode:16; [Purchase_Orders_Items:12]SubGroup:13)  //tsubgroup (initialized to entered RM in script for RM Code field)

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