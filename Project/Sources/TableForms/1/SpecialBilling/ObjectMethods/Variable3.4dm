$numfound:=qryFinishedGood([Customers_Order_Change_Orders:34]CustID:2; sDesc)
If ($numfound>0)
	BEEP:C151
	ALERT:C41("Must use 'Other FG' button to add a Finished Good.")
	sDesc:="Preparatory"
End if 
//