//%attributes = {"publishedWeb":true}
//uPOitemLikeRM
//$1 - strin(optional) anything flag - call ReqCalcItem instead of sPoItemCalc
//upr 1294 11/2/94
//12/28/94
//Upr 0235 - Cs - 12/3/96 - chargecode change
//•UPR 0235 -cs - 1/31/97(continued) get default company from Purchase order
//• 6/11/97 cs upr 1872 -add parameter to flag sPOItemCalc to call ReqCalcItmVal
//• 9/4/97 cs try to solve problem carol is having with array bounds
//•061499  mlb  option to make current exp code like rm's

If (RMG_is_CommodityKey_Valid([Raw_Materials:21]Commodity_Key:2))
	[Purchase_Orders_Items:12]CommodityCode:16:=[Raw_Materials:21]CommodityCode:26
	[Purchase_Orders_Items:12]SubGroup:13:=[Raw_Materials:21]SubGroup:31
	[Purchase_Orders_Items:12]Commodity_Key:26:=[Raw_Materials:21]Commodity_Key:2
Else 
	uConfirm([Raw_Materials:21]Raw_Matl_Code:1+"'s Commodity Key is no longer valid. Set it on the PO Item screen."; "OK"; "Help")
	[Purchase_Orders_Items:12]CommodityCode:16:=0
	[Purchase_Orders_Items:12]SubGroup:13:=""
	[Purchase_Orders_Items:12]Commodity_Key:26:=""
End if 

[Purchase_Orders_Items:12]Raw_Matl_Code:15:=[Raw_Materials:21]Raw_Matl_Code:1
[Purchase_Orders_Items:12]RM_Description:7:=[Raw_Materials:21]Description:4
[Purchase_Orders_Items:12]UM_Ship:5:=[Raw_Materials:21]ReceiptUOM:9
[Purchase_Orders_Items:12]UM_Arkay_Issue:28:=[Raw_Materials:21]IssueUOM:10
[Purchase_Orders_Items:12]UM_Price:24:=[Purchase_Orders_Items:12]UM_Ship:5

[Purchase_Orders_Items:12]FactNship2cost:29:=[Raw_Materials:21]ConvertRatio_N:16
[Purchase_Orders_Items:12]FactDship2cost:37:=[Raw_Materials:21]ConvertRatio_D:17
// Modified by: Mel Bohince (4/10/17) 
[Purchase_Orders_Items:12]FactNship2price:25:=[Raw_Materials:21]ConvertPrice_N:35
[Purchase_Orders_Items:12]FactDship2price:38:=[Raw_Materials:21]ConvertPrice_D:36

[Purchase_Orders_Items:12]UnitPrice:10:=[Raw_Materials:21]LastPurCost:43
If ([Purchase_Orders_Items:12]UnitPrice:10=0)
	[Purchase_Orders_Items:12]UnitPrice:10:=[Raw_Materials:21]ActCost:45
End if 
[Purchase_Orders_Items:12]Flex1:31:=[Raw_Materials:21]Flex1:19
[Purchase_Orders_Items:12]Flex2:32:=[Raw_Materials:21]Flex2:20
[Purchase_Orders_Items:12]Flex3:33:=[Raw_Materials:21]Flex3:21
[Purchase_Orders_Items:12]Flex4:34:=[Raw_Materials:21]Flex4:22
[Purchase_Orders_Items:12]Flex5:35:=[Raw_Materials:21]Flex5:23
[Purchase_Orders_Items:12]Flex6:36:=[Raw_Materials:21]Flex6:24

If (Length:C16([Purchase_Orders:11]VendorID:2)=5)  //vendor all ready specified
	
	QUERY:C277([Raw_Materials_Suggest_Vendors:173]; [Raw_Materials_Suggest_Vendors:173]id_added_by_converter:9=[Raw_Materials:21]Suggest_Vendors:49; *)
	QUERY:C277([Raw_Materials_Suggest_Vendors:173];  & ; [Raw_Materials_Suggest_Vendors:173]VendorID:1=[Purchase_Orders:11]VendorID:2)
	$numVend:=Records in selection:C76([Raw_Materials_Suggest_Vendors:173])
	If ($numVend=0)  //add this one
		QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Purchase_Orders:11]VendorID:2)
		CREATE RECORD:C68([Raw_Materials_Suggest_Vendors:173])
		[Raw_Materials_Suggest_Vendors:173]VendorID:1:=[Purchase_Orders:11]VendorID:2
		[Raw_Materials_Suggest_Vendors:173]Name:4:=[Vendors:7]Name:2
		[Raw_Materials_Suggest_Vendors:173]id_added_by_converter:9:=[Raw_Materials:21]Suggest_Vendors:49
		[Raw_Materials_Suggest_Vendors:173]VendorPartNumber:3:=[Purchase_Orders_Items:12]VendPartNo:6
		[Raw_Materials_Suggest_Vendors:173]Raw_Matl_Code:2:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
		[Raw_Materials_Suggest_Vendors:173]FactNShip2price:7:=[Purchase_Orders_Items:12]FactNship2price:25
		[Raw_Materials_Suggest_Vendors:173]FactDship2price:8:=[Purchase_Orders_Items:12]FactDship2price:38
		[Raw_Materials_Suggest_Vendors:173]UMprice:6:=[Purchase_Orders_Items:12]UM_Price:24
		SAVE RECORD:C53([Raw_Materials_Suggest_Vendors:173])
		REDUCE SELECTION:C351([Raw_Materials_Suggest_Vendors:173]; 0)
		$numVend:=1
	End if 
	
Else 
	[Purchase_Orders:11]VendorID:2:=""
	[Purchase_Orders:11]VendorName:42:=""
	RELATE MANY:C262([Raw_Materials:21]Suggest_Vendors:49)
	$numVend:=Records in selection:C76([Raw_Materials_Suggest_Vendors:173])
	
	ARRAY TEXT:C222($aVendorId; 0)
	While (Not:C34(End selection:C36([Raw_Materials_Suggest_Vendors:173])))
		QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Raw_Materials_Suggest_Vendors:173]VendorID:1)
		If (Records in selection:C76([Vendors:7])=1)  //good, use it then break
			[Purchase_Orders:11]VendorID:2:=[Raw_Materials_Suggest_Vendors:173]VendorID:1
			[Purchase_Orders_Items:12]VendPartNo:6:=[Raw_Materials_Suggest_Vendors:173]VendorPartNumber:3
			[Purchase_Orders_Items:12]FactNship2price:25:=[Raw_Materials_Suggest_Vendors:173]FactNShip2price:7
			[Purchase_Orders_Items:12]FactDship2price:38:=[Raw_Materials_Suggest_Vendors:173]FactDship2price:8
			[Purchase_Orders_Items:12]UM_Price:24:=[Raw_Materials_Suggest_Vendors:173]UMprice:6
			LAST RECORD:C200([Raw_Materials_Suggest_Vendors:173])
		End if 
		NEXT RECORD:C51([Raw_Materials_Suggest_Vendors:173])
	End while 
	REDUCE SELECTION:C351([Raw_Materials_Suggest_Vendors:173]; 0)
	If ($numVend>1) & (Length:C16([Purchase_Orders:11]VendorID:2)=5)
		uConfirm("Warning: More than one Vendor supplies this Part Number."+Char:C90(13)+"Vendor# "+[Purchase_Orders:11]VendorID:2+" is being used."; "I'll Check"; "Help")
	End if 
	
	QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Purchase_Orders:11]VendorID:2)
	If (Records in selection:C76([Vendors:7])=1)
		PoVendorAssign
		[Purchase_Orders_Items:12]VendorID:39:=[Purchase_Orders:11]VendorID:2
	Else 
		[Purchase_Orders:11]VendorID:2:=""
		[Purchase_Orders:11]VendorName:42:=""
	End if 
End if 

If (Count parameters:C259=1)  //• 6/11/97 cs 
	ReqCalcItmValue
Else 
	sCalcPoItemVals  //added 12/28/94
End if 

If (Length:C16([Purchase_Orders_Items:12]UM_Ship:5)=0)
	[Purchase_Orders_Items:12]UM_Ship:5:=[Purchase_Orders_Items:12]UM_Arkay_Issue:28
End if 

If (Length:C16([Purchase_Orders_Items:12]UM_Price:24)=0)
	[Purchase_Orders_Items:12]UM_Price:24:=[Purchase_Orders_Items:12]UM_Ship:5
End if 