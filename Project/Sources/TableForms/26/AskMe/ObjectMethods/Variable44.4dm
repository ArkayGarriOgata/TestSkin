//SEARCH([FG_Transactions];[FG_Transactions]ProductCode=[Finished_Goods]ProductCod
//SEARCH([FG_Transactions]; & [FG_Transactions]CustID=[Finished_Goods]CustID)
rQtyRecd:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
rStdExtCost:=Sum:C1([Finished_Goods_Transactions:33]zCount:10)
//