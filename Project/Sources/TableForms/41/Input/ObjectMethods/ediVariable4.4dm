[Customers_Order_Lines:41]Quantity:6:=[Customers_Order_Lines:41]edi_quantity:65
[Customers_Order_Lines:41]Qty_Booked:48:=[Customers_Order_Lines:41]Quantity:6
[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6-[Customers_Order_Lines:41]Qty_Shipped:10+[Customers_Order_Lines:41]Qty_Returned:35
[Customers_Order_Lines:41]chgd_qty:28:=True:C214

APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Qty:6:=[Customers_Order_Lines:41]Qty_Open:11)
