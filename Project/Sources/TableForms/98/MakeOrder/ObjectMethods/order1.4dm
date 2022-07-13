//OM: vOrd() -> 
//@author mlb - 8/28/02  11:06

QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=vOrd; *)
QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]ProjectNumber:53=[Finished_Goods_Specifications:98]ProjectNumber:4)
If (Records in selection:C76([Customers_Orders:40])#1)
	BEEP:C151
	ALERT:C41("Order Nº "+String:C10(vOrd)+" was not found "+Char:C90(13)+"or wasn't for Project Nº "+[Finished_Goods_Specifications:98]ProjectNumber:4; "Try again")
	vOrd:=0
	GOTO OBJECT:C206(vOrd)
End if 