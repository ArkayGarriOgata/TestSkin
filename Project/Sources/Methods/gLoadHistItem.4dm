//%attributes = {"publishedWeb":true}
//(p) gLoadHistItem 
//bring data over from finished good

[Customers_Order_Changed_Items:176]NewProductCode:10:=[Finished_Goods:26]ProductCode:1
[Customers_Order_Changed_Items:176]NewBillto:25:=[Customers_Orders:40]defaultBillTo:5
[Customers_Order_Changed_Items:176]NewShipto:27:=[Customers_Orders:40]defaultShipto:40
[Customers_Order_Changed_Items:176]NewClassificati:35:=[Finished_Goods:26]ClassOrType:28
[Customers_Order_Changed_Items:176]NewLaborCost:19:=[Finished_Goods:26]LastCost:26*0.2
[Customers_Order_Changed_Items:176]NewMatlCost:17:=[Finished_Goods:26]LastCost:26*0.6
[Customers_Order_Changed_Items:176]NewOHCost:21:=[Finished_Goods:26]LastCost:26*0.2
[Customers_Order_Changed_Items:176]NewOrdType:15:=[Finished_Goods:26]OriginalOrRepeat:71