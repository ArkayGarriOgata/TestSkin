//(S) [CUSTOMER]SalesAnalystID

QUERY:C277([Users:5]; [Users:5]Initials:1=[Customers:16]SalesCoord:45)
If (Records in selection:C76([Users:5])=0)
	ALERT:C41("Sales Coordinator's initials not found in user file.")
	GOTO OBJECT:C206([Customers:16]SalesCoord:45)
	//HIGHLIGHT TEXT(PlannerID;1;4)
End if 
UNLOAD RECORD:C212([Users:5])