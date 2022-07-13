//Script: PayU()  092595  MLB
//•092595  MLB  UPR 1729
APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]PayUse:47:=[Customers_Orders:40]PayUse:50)
QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=(String:C10([Customers_Orders:40]OrderNumber:1; "00000")+"@"))
APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]PayU:31:=Num:C11([Customers_Orders:40]PayUse:50))
//