QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=sCPN; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]CustID:12=sCustID)
//SEARCH([FG_Transactions]; & [FG_Transactions]XactionType="Rev@")
//
rQtyRecd:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
rStdExtCost:=Sum:C1([Finished_Goods_Transactions:33]zCount:10)