//%attributes = {}
sCPN:="2EFP-01-0114"
sCustID:="00015"
READ WRITE:C146([Customers_Order_Lines:41])
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=sCPN)
APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4:=sCustID)
APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24:=CUST_getName(sCustID))
READ WRITE:C146([Customers_ReleaseSchedules:46])
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=sCPN)
APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12:=sCustID)
READ WRITE:C146([Finished_Goods_Locations:35])
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=sCPN)
APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16:=sCustID)
READ WRITE:C146([Finished_Goods_Transactions:33])
QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=sCPN)
APPLY TO SELECTION:C70([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12:=sCustID)
READ WRITE:C146([Job_Forms_Items:44])
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=sCPN)
APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]CustId:15:=sCustID)
READ WRITE:C146([Job_Forms_Items_Costs:92])
QUERY:C277([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]FG_Key:13=("@"+sCPN))
APPLY TO SELECTION:C70([Job_Forms_Items_Costs:92]; [Job_Forms_Items_Costs:92]FG_Key:13:=sCustID+":"+sCPN)
//•