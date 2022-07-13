//(S) [PO_CHG_ORDERS]Input'ChgOrdStatus
If (([Purchase_Orders_Chg_Orders:13]ChgOrdStatus:10="Approved") | ([Purchase_Orders_Chg_Orders:13]ChgOrdStatus:10="CO Approved")) & (Not:C34(User in group:C338(Current user:C182; "PO_Approval")))
	[Purchase_Orders_Chg_Orders:13]ChgOrdStatus:10:=Old:C35([Purchase_Orders_Chg_Orders:13]ChgOrdStatus:10)
	BEEP:C151
	ALERT:C41("You don't have authority to approve a PO Change Order!")
Else 
	[Purchase_Orders_Chg_Orders:13]StatusBy:12:=<>zResp
	[Purchase_Orders_Chg_Orders:13]StatusDate:13:=Current date:C33
End if 