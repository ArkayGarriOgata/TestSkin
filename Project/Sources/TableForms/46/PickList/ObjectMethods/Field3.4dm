QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_ReleaseSchedules:46]ProductCode:11; *)
QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Customers_ReleaseSchedules:46]CustID:12; *)
QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]QtyOH:9>0)
ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19; >; [Finished_Goods_Locations:35]Location:2; >)
//