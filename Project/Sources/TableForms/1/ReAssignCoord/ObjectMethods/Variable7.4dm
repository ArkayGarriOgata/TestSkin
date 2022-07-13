READ ONLY:C145([Users:5])
QUERY:C277([Users:5]; [Users:5]Initials:1=vNewRep)
If (Records in selection:C76([Users:5])#1)
	BEEP:C151
	ALERT:C41(vNewRep+" was not found.")
	vNewRep:=""
	t2:=""
	GOTO OBJECT:C206(vNewRep)
Else 
	t2:=[Users:5]FirstName:3+" "+[Users:5]MI:4+" "+[Users:5]LastName:2
End if 
//