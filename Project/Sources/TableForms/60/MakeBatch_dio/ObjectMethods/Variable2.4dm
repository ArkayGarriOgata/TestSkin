READ ONLY:C145([Purchase_Orders_Items:12])
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sCriterion2)
If (Records in selection:C76([Purchase_Orders_Items:12])=1)
	BEEP:C151
	ALERT:C41("Sorry, that number has been used by Purchasing")
	sCriterion2:=""
	uClearSelection(->[Purchase_Orders_Items:12])
End if 
//