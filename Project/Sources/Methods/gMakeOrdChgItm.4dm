//%attributes = {"publishedWeb":true}
//(p) gMakeOrdChgItm
//upr 1268 (entire procedure) 02/17/95 chip
//rinclxxxx from dialog NewOrdItem
//added classification defaults 03/29/95 per meeting upr 1444
//•071495  MLB  UPR 
//[OrderLines]LineItem:=r1

[Customers_Order_Changed_Items:176]NewProductCode:10:=sDesc
[Customers_Order_Changed_Items:176]NewClassificati:35:=String:C10(r2; "00")
[Customers_Order_Changed_Items:176]NewQty:4:=r3
[Customers_Order_Changed_Items:176]NewMatlCost:17:=r4  //•071495  MLB  UPR §
[Customers_Order_Changed_Items:176]NewLaborCost:19:=r6  //•071495  MLB  UPR §
[Customers_Order_Changed_Items:176]NewOHCost:21:=r7  //•071495  MLB  UPR §
[Customers_Order_Changed_Items:176]NewCost:14:=r4+r6+r7  //•071495  MLB  UPR §
[Customers_Order_Changed_Items:176]NewPrice:5:=r5  //•051595  MLB  UPR 1508
[Customers_Order_Changed_Items:176]SpecialBilling:38:=True:C214
SAVE RECORD:C53([Customers_Order_Changed_Items:176])

$numfound:=qryFinishedGood("#PREP"; sDesc)
//QUERY([Finished_Goods];[Finished_Goods]FG_KEY=[OrderLines]ProductCode)
If (Records in selection:C76([Finished_Goods:26])=0)
	ORD_AddSpecialFG  //4/26/95 refered to procedure so that creation in many places is in sync  
End if 