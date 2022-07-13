//•060295  MLB  UPR 184 add brand to orderlines
[Customers_Orders:40]CustomerLine:22:=util_ComboBoxAction(->aBrand)
APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerLine:42:=aBrand{aBrand})
