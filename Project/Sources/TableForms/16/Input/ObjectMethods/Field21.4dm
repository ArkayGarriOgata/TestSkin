//(S) [CUSTOMER]PlannerID

QUERY:C277([Users:5]; [Users:5]Initials:1=[Customers:16]PlannerID:5)
If (Records in selection:C76([Users:5])=0)
	ALERT:C41("Planner's initials not found in user file.")
	//Text12:=""
	GOTO OBJECT:C206([Customers:16]PlannerID:5)
	//HIGHLIGHT TEXT(PlannerID;1;4)
Else 
	// Text12:=[USER]FirstName+" "+[USER]MI+" "+[USER]LastName
End if 
UNLOAD RECORD:C212([Users:5])