READ ONLY:C145([Estimates:17])
QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=[Customers_Orders:40]EstimateNo:3)
If (Records in selection:C76([Estimates:17])>0)
	pattern_PassThru(->[Estimates:17])
	ViewSetter(3; ->[Estimates:17])
Else 
	uConfirm("Could not find estimate "+[Customers_Orders:40]EstimateNo:3)
End if 
REDUCE SELECTION:C351([Estimates:17]; 0)