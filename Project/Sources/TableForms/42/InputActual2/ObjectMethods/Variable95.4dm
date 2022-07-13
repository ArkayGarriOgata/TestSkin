//(S) bSearchAll
fSchTrans:=False:C215
QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5=[Job_Forms:42]JobFormID:5)
ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1; >; [Finished_Goods_Transactions:33]XactionDate:3; >; [Finished_Goods_Transactions:33]viaLocation:11; <)
rTotXfer:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
//EOS