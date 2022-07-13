//%attributes = {"publishedWeb":true}
//sPOIClearRM
//clear POI data relating to RM if RM code is cleared or RM selection fails
//• 4/11/97 cs 
//•6/25/97 cs
fNewRm:=False:C215
[Purchase_Orders_Items:12]RM_Description:7:=""
[Purchase_Orders_Items:12]UM_Ship:5:=""
[Purchase_Orders_Items:12]UM_Price:24:=""
[Purchase_Orders_Items:12]UM_Arkay_Issue:28:=""

If (Count parameters:C259=0)
	[Purchase_Orders_Items:12]DepartmentID:46:=""
	[Purchase_Orders_Items:12]ExpenseCode:47:=""
End if 

[Purchase_Orders_Items:12]FactNship2cost:29:=1
[Purchase_Orders_Items:12]FactDship2cost:37:=1
[Purchase_Orders_Items:12]UnitPrice:10:=0
[Purchase_Orders_Items:12]Flex1:31:=0
[Purchase_Orders_Items:12]Flex2:32:=0
[Purchase_Orders_Items:12]Flex3:33:=0
[Purchase_Orders_Items:12]Flex4:34:=""
[Purchase_Orders_Items:12]Flex5:35:=""
[Purchase_Orders_Items:12]Flex6:36:=""
[Purchase_Orders_Items:12]VendPartNo:6:=""
[Purchase_Orders_Items:12]FactNship2price:25:=1
[Purchase_Orders_Items:12]FactDship2price:38:=1
[Purchase_Orders_Items:12]ExtPrice:11:=0
r1:=0  //•6/25/97 cs addd for vars which display budget info
r2:=0
r3:=0
r4:=0
tSubGroup:=""  //• 4/11/97 cs 
iComm:=0  //• 4/11/97 cs 