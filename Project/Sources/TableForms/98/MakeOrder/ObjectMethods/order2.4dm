//OM: vOrd apply charges() -> 
//@author mlb - 8/28/02  11:03

zwStatusMsg("ApplyCharge"; "Calculating dollars that can be distributed on this order, Please Wait...")
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=vOrd; *)
QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]ProjectNumber:53=[Finished_Goods_Specifications:98]ProjectNumber:4)
If (Records in selection:C76([Customers_Orders:40])=1)
	rDistributed:=ORD_distributePrepAvailable(vOrd)-ORD_distributePrepConsumed(vOrd)
	zwStatusMsg("ApplyCharge"; String:C10(rDistributed)+" Dollars can be distributed on this order.")
	If (rDistributed<=0)
		BEEP:C151
		ALERT:C41("Order Nº "+String:C10(vOrd)+" has already been fully distributed.")
		vOrd:=0
		REDUCE SELECTION:C351([Customers_Orders:40]; 0)
		REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
		REDUCE SELECTION:C351([Prep_Charges:103]; 0)
		GOTO OBJECT:C206(vOrd)
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Order Nº "+String:C10(vOrd)+" was not found "+Char:C90(13)+"or wasn't for Project Nº "+[Finished_Goods_Specifications:98]ProjectNumber:4; "Try again")
	vOrd:=0
	GOTO OBJECT:C206(vOrd)
End if 