QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sCriterion2)
If (Records in selection:C76([Purchase_Orders_Items:12])=0)
	BEEP:C151
	ALERT:C41("Invalid PO item key!")
	GOTO OBJECT:C206(sCriterion2)
End if 