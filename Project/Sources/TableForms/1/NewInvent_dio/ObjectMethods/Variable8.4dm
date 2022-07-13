QUERY:C277([Customers:16]; [Customers:16]Name:2=tCust)
If (Records in selection:C76([Customers:16])=0)
	BEEP:C151
	ALERT:C41(tCust+" is not a valid customer name.")
	tCust:=""
	GOTO OBJECT:C206(tCust)
End if 
//