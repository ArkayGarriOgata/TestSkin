If (Form event code:C388=On Load:K2:1)
	ARRAY TEXT:C222(aPO; 0)
	ARRAY LONGINT:C221(aItem; 0)
	ARRAY DATE:C224(aDate; 0)
	ARRAY LONGINT:C221(aQty; 0)
	QUERY:C277([Customers_BilledPayUse:86]; [Customers_BilledPayUse:86]Orderline:1=[Customers_Order_Lines:41]OrderLine:3)
	SELECTION TO ARRAY:C260([Customers_BilledPayUse:86]CustReleaseNum:3; aPO; [Customers_BilledPayUse:86]Invoice:4; aItem; [Customers_BilledPayUse:86]InvoiceDate:5; aDate; [Customers_BilledPayUse:86]QuantityBilled:6; aQty)
	SORT ARRAY:C229(aItem; aDate; aQty; aPO; >)
	
End if 
//