//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): MLB
// ----------------------------------------------------
// Method: POI_LockDownRMcode
// Description:
// Disable input areas when an exising RM code has been selected
// ----------------------------------------------------

If (Records in selection:C76([Raw_Materials:21])=1)  //then it already exists
	ARRAY TEXT:C222(aCommCode; 0)
	ARRAY TEXT:C222(aSubGroup; 0)  //• 7/15/97 cs missed disabling when in rev 
	
	// Modified by: Mark Zinke (5/6/13) Changed to SetObjectProperites
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]Raw_Matl_Code:15; True:C214; ""; False:C215)
	SetObjectProperties(""; ->sCriterion1; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]CommodityCode:16; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]SubGroup:13; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]UM_Ship:5; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]UM_Price:24; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]UM_Arkay_Issue:28; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]FactNship2price:25; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]FactNship2cost:29; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]FactDship2cost:37; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]FactDship2price:38; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex1:31; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex2:32; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex4:34; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex5:35; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex6:36; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]VendPartNo:6; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]RM_Description:7; True:C214; ""; False:C215)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]Flex3:33; True:C214; ""; False:C215)
	
Else 
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]Raw_Matl_Code:15; True:C214; ""; True:C214)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]VendPartNo:6; True:C214; ""; True:C214)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]CommodityCode:16; True:C214; ""; True:C214)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]SubGroup:13; True:C214; ""; True:C214)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]UM_Ship:5; True:C214; ""; True:C214)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]UM_Price:24; True:C214; ""; True:C214)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]UM_Arkay_Issue:28; True:C214; ""; True:C214)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]FactNship2price:25; True:C214; ""; True:C214)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]FactNship2cost:29; True:C214; ""; True:C214)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]FactDship2cost:37; True:C214; ""; True:C214)
	SetObjectProperties(""; ->[Purchase_Orders_Items:12]FactDship2price:38; True:C214; ""; True:C214)
End if 