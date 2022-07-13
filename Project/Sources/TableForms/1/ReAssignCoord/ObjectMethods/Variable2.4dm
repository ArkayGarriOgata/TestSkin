//upr 1307
//12/6/94 got rid of double first name
//•021197  mBohince  
READ WRITE:C146([Estimates:17])
READ WRITE:C146([Customers_Orders:40])
READ WRITE:C146([Customers:16])
If (rb1=1)  //by one custoemr
	QUERY:C277([Customers:16]; [Customers:16]ID:1=vCust)
	If (Records in selection:C76([Customers:16])=1)
		t1:=[Customers:16]Name:2
		vOldRep:=[Customers:16]SalesCoord:45
		READ ONLY:C145([Users:5])
		QUERY:C277([Users:5]; [Users:5]Initials:1=vOldRep)
		t1:=t1+Char:C90(13)+"Current sales coordinator is : "+vOldRep+", "+[Users:5]FirstName:3+" "+[Users:5]MI:4+" "+[Users:5]LastName:2
		QUERY:C277([Estimates:17]; [Estimates:17]Cust_ID:2=vCust)
		t1:=t1+String:C10(Records in selection:C76([Estimates:17]))+" Estimate records. "
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]CustID:2=vCust)  //upr 1307
		t1:=t1+String:C10(Records in selection:C76([Customers_Orders:40]))+" CustomerOrder records. "
	Else 
		BEEP:C151
		ALERT:C41(vCust+" was not found.")
		vCust:="00000"
		t1:=""
		GOTO OBJECT:C206(vCust)
	End if 
	
Else 
	vOldRep:=vCust
	QUERY:C277([Customers:16]; [Customers:16]SalesCoord:45=vOldRep)
	If (Records in selection:C76([Customers:16])>0)
		t1:=String:C10(Records in selection:C76([Customers:16]))+" Customer records. "
		vOldRep:=[Customers:16]SalesCoord:45
		READ ONLY:C145([Users:5])
		QUERY:C277([Users:5]; [Users:5]Initials:1=vOldRep)
		t1:=t1+Char:C90(13)+"Current sales coordinator is : "+vOldRep+", "+[Users:5]FirstName:3+" "+[Users:5]MI:4+" "+[Users:5]LastName:2
		QUERY:C277([Estimates:17]; [Estimates:17]SaleCoord:46=vOldRep)
		t1:=t1+String:C10(Records in selection:C76([Estimates:17]))+" Estimate records. "
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]SalesCoord:46=vOldRep)  //upr 1307
		t1:=t1+String:C10(Records in selection:C76([Customers_Orders:40]))+" CustomerOrder records. "
	Else 
		BEEP:C151
		ALERT:C41(vCust+" was not found.")
		vCust:=""
		t1:=""
		GOTO OBJECT:C206(vCust)
	End if 
End if 
//