//%attributes = {"publishedWeb":true}
//PM:  ORD_AddItemSplBilling  110899  mlb
//formerly  `doOrderAddItem2     --JML   9/17/93
//called by doOpenOrder2()
//4/26/95 chip
//•051595  MLB  UPR 1508
//•071495  MLB  UPR 222

C_TEXT:C284($1)  //non f/g item
C_REAL:C285($2; $3)  //cost & price

CREATE RECORD:C68([Customers_Order_Lines:41])
[Customers_Order_Lines:41]OrderNumber:1:=vord
[Customers_Order_Lines:41]LineItem:2:=vi
$ordLine:=fMakeOLkey(vord; vi)
//$ordLine:=String(vord;"00000")+"."+String(vi;"00")
[Customers_Order_Lines:41]OrderLine:3:=$ordLine
[Customers_Order_Lines:41]CustID:4:=vcust
$pCode:=$1  //[CARTON_SPEC]ProductCode
[Customers_Order_Lines:41]ProductCode:5:=$pCode
If (Count parameters:C259=5)  //qty pased in from 'other'
	[Customers_Order_Lines:41]Quantity:6:=$5
Else 
	[Customers_Order_Lines:41]Quantity:6:=1
End if 
[Customers_Order_Lines:41]Cost_Per_M:7:=$2
[Customers_Order_Lines:41]CostOH_Per_M:31:=$2  //•071495  MLB  UPR 222
[Customers_Order_Lines:41]Price_Per_M:8:=$3
vestP:=vestP+(([Customers_Order_Lines:41]Quantity:6)*[Customers_Order_Lines:41]Price_Per_M:8)
vestC:=vestC+(([Customers_Order_Lines:41]Quantity:6)*[Customers_Order_Lines:41]Cost_Per_M:7)
[Customers_Order_Lines:41]Status:9:="Opened"
[Customers_Order_Lines:41]DateOpened:13:=4D_Current_date
[Customers_Order_Lines:41]Qty_Shipped:10:=0
[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6
uLinesLikeOrder
If (Count parameters:C259>=4)  //used for special billing items
	[Customers_Order_Lines:41]OrderType:22:="Preparatory"  //•071495  MLB  UPR 222  
	[Customers_Order_Lines:41]SpecialBilling:37:=True:C214
	[Customers_Order_Lines:41]Classification:29:=$4
	$numFG:=qryFinishedGood("#PREP"; $pCode)
	If ($numFG=0)  //4/26/95 chip
		ORD_AddSpecialFG(vord; $pCode)  //4/26/95 chip
	End if   //4/26/95 chip
End if 

SAVE RECORD:C53([Customers_Order_Lines:41])