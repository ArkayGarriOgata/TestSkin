//%attributes = {"publishedWeb":true}
//uVerifyShipment

QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=[Customers_Order_Lines:41]OrderLine:3+"@"; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Ship")
[Customers_Order_Lines:41]Qty_Shipped:10:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6-[Customers_Order_Lines:41]Qty_Shipped:10+[Customers_Order_Lines:41]Qty_Returned:35