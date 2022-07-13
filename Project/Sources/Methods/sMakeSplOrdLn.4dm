//%attributes = {"publishedWeb":true}
//(p) sMakeSplOrdLn
//rinclxxxx from dialog NewOrdItem
//upr 1444
//mod 4/19/95 chip, 
//mod 4/26/95 chip
//•051595  MLB  UPR 1508
//•061295  MLB  UPR 1641 send an API trans for F/G's that are created
//•021997  MLB  UPR 1853 set qty open
//• 11/3/97 cs chnagd class assig to force incl of leading zero
//• 4/9/98 cs nan checking/removal

C_LONGINT:C283($0)

CREATE RECORD:C68([Customers_Order_Lines:41])
[Customers_Order_Lines:41]LineItem:2:=i1
[Customers_Order_Lines:41]ProductCode:5:=sDesc
[Customers_Order_Lines:41]SpecialBilling:37:=True:C214
[Customers_Order_Lines:41]Classification:29:=String:C10(r2; "00")
[Customers_Order_Lines:41]Quantity:6:=r3
[Customers_Order_Lines:41]Qty_Open:11:=r3  //•021997  MLB  UPR 1853
[Customers_Order_Lines:41]CostMatl_Per_M:32:=r4  //•071495  MLB  UPR §
[Customers_Order_Lines:41]CostLabor_Per_M:30:=r6  //•071495  MLB  UPR §
[Customers_Order_Lines:41]CostOH_Per_M:31:=r7  //•071495  MLB  UPR §
[Customers_Order_Lines:41]Cost_Per_M:7:=r4+r6+r7  //•071495  MLB  UPR §
[Customers_Order_Lines:41]Price_Per_M:8:=r5  //•051595  MLB  UPR 1508
uLinesLikeOrder
[Customers_Order_Lines:41]OrderLine:3:=fMakeOLkey([Customers_Order_Lines:41]OrderNumber:1; i1)
[Customers_Order_Lines:41]CustID:4:=[Customers_Orders:40]CustID:2
[Customers_Order_Lines:41]Status:9:="Opened"
[Customers_Order_Lines:41]DateOpened:13:=4D_Current_date
SAVE RECORD:C53([Customers_Order_Lines:41])

$numfound:=qryFinishedGood("#PREP"; sDesc)
If (Records in selection:C76([Finished_Goods:26])=0)
	ORD_AddSpecialFG  //4/26/95 refered to procedure so that creation in many places is in sync  
End if 

$0:=i1