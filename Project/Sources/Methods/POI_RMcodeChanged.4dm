//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/10/06, 17:36:39
// ----------------------------------------------------
// Method: POI_RMcodeChanged
// ----------------------------------------------------

fNewRM:=False:C215

POI_makeLikeRM
util_ComboBoxSetup(->aUOM1; [Purchase_Orders_Items:12]UM_Ship:5)
util_ComboBoxSetup(->aUOM2; [Purchase_Orders_Items:12]UM_Arkay_Issue:28)
util_ComboBoxSetup(->aUOM3; [Purchase_Orders_Items:12]UM_Price:24)

util_ComboBoxSetup(->aCommCode; String:C10([Purchase_Orders_Items:12]CommodityCode:16; "00"))
POCommCode

util_ComboBoxSetup(->aSubgroup; [Purchase_Orders_Items:12]SubGroup:13)
POSubGroup

If (Length:C16([Purchase_Orders_Items:12]Commodity_Key:26)>2)  //it has been set so restrict
	If (Not:C34(User in group:C338(Current user:C182; "RoleCostAccountant")))
		OBJECT SET ENABLED:C1123(aCommCode; False:C215)
		OBJECT SET ENABLED:C1123(aSubGroup; False:C215)
	End if 
End if 