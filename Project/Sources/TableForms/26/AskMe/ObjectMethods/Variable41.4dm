QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=sCPN; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]CustID:12=sCUstID)
// ******* Verified  - 4D PS - January  2019 ********

QUERY SELECTION:C341([Finished_Goods_Transactions:33])


// ******* Verified  - 4D PS - January 2019 (end) *********
rQtyRecd:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
rStdExtCost:=Sum:C1([Finished_Goods_Transactions:33]zCount:10)