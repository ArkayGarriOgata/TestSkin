READ WRITE:C146([Customers:16])  //••
If ((vCust#"00000") & (vNewRep#"") & (vCust#""))
	
	Repeat 
		APPLY TO SELECTION:C70([Customers:16]; [Customers:16]SalesCoord:45:=vNewRep)
		USE SET:C118("LockedSet")
		If (Records in selection:C76([Customers:16])>0)
			MESSAGE:C88("Waiting for "+String:C10(Records in selection:C76([Customers:16]))+" [CUSTOMER] locked records.")
		End if 
	Until (Records in set:C195("LockedSet")=0)
	
	Repeat 
		APPLY TO SELECTION:C70([Estimates:17]; [Estimates:17]SaleCoord:46:=vNewRep)
		USE SET:C118("LockedSet")  //ApplicationName
		If (Records in selection:C76([Estimates:17])>0)
			MESSAGE:C88("Waiting for "+String:C10(Records in selection:C76([Estimates:17]))+" [ESTIMATE] locked records.")
		End if 
	Until (Records in set:C195("LockedSet")=0)
	
	Repeat 
		APPLY TO SELECTION:C70([Customers_Orders:40]; [Customers_Orders:40]SalesCoord:46:=vNewRep)
		USE SET:C118("LockedSet")
		If (Records in selection:C76([Customers_Orders:40])>0)
			MESSAGE:C88("Waiting for "+String:C10(Records in selection:C76([Customers_Orders:40]))+" [CustomerOrder] locked records.")
		End if 
	Until (Records in set:C195("LockedSet")=0)
	
	t3:=t3+"  "+vCust+"->"+vNewRep
	UNLOAD RECORD:C212([Customers:16])
	UNLOAD RECORD:C212([Estimates:17])
	UNLOAD RECORD:C212([Customers_Orders:40])
	vCust:="00000"
	vNewRep:=""
	t1:=""
	t2:=""
	BEEP:C151
Else 
	BEEP:C151
	BEEP:C151
	ALERT:C41("Both a customer and a new rep is required for reassigning.")
End if 
//
//