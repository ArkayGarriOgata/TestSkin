//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/10/06, 15:35:25
// ----------------------------------------------------
// Method: POI_ClearInputForm
// ----------------------------------------------------

If (Count parameters:C259=1)
	[Purchase_Orders_Items:12]Raw_Matl_Code:15:=fStripSpace("B"; $1)
Else 
	[Purchase_Orders_Items:12]Raw_Matl_Code:15:=""
End if 
[Purchase_Orders_Items:12]VendPartNo:6:=""
[Purchase_Orders_Items:12]ExtPrice:11:=0
[Purchase_Orders_Items:12]FactNship2cost:29:=1
[Purchase_Orders_Items:12]FactDship2cost:37:=1
[Purchase_Orders_Items:12]FactDship2price:38:=1
[Purchase_Orders_Items:12]FactNship2price:25:=1
[Purchase_Orders_Items:12]RM_Description:7:=""
[Purchase_Orders_Items:12]UM_Ship:5:=""
[Purchase_Orders_Items:12]UM_Arkay_Issue:28:=""
[Purchase_Orders_Items:12]UM_Price:24:=""
[Purchase_Orders_Items:12]UnitPrice:10:=0
[Purchase_Orders_Items:12]Flex1:31:=0
[Purchase_Orders_Items:12]Flex2:32:=0
[Purchase_Orders_Items:12]Flex3:33:=0
[Purchase_Orders_Items:12]Flex4:34:=""
[Purchase_Orders_Items:12]Flex5:35:=""
[Purchase_Orders_Items:12]Flex6:36:=""
[Purchase_Orders_Items:12]Qty_Shipping:4:=0  //q-mail 1/20/95
[Purchase_Orders_Items:12]ExtPrice:11:=0
[Purchase_Orders_Items:12]Qty_Ordered:30:=0  //q-mail 1/20/95