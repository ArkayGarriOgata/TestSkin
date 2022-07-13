//(s) [control]ReAssgnCust'vNewRep
QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=vNewRep)

If (Records in selection:C76([Salesmen:32])#1)
	BEEP:C151
	ALERT:C41(vNewRep+" was not found in Salesman file.")
	vNewRep:=""
	t2:=""
	t1:=""
	GOTO OBJECT:C206(vNewRep)
Else 
	Self:C308->:=Uppercase:C13(Self:C308->)
	t2:=[Salesmen:32]FirstName:3+" "+[Salesmen:32]MI:4+" "+[Salesmen:32]LastName:2
End if 
//