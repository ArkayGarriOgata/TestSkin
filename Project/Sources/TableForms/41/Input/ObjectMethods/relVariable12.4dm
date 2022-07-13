//Script: [Orderline].Input.+.bRelAdd()  102297  MLB
//•060295  MLB  UPR 184 add brand
//•101995  MLB 
//•102297  MLB  was, -4, chg so it show up as not being processed yet
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "currentRels")
		
	Else 
		
		ARRAY LONGINT:C221($_currentRels; 0)
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]; $_currentRels)
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	
	ARRAY LONGINT:C221($_currentRels; 0)
	LONGINT ARRAY FROM SELECTION:C647([Customers_ReleaseSchedules:46]; $_currentRels)
	
End if   // END 4D Professional Services : January 2019 

CREATE RECORD:C68([Customers_ReleaseSchedules:46])
[Customers_ReleaseSchedules:46]ReleaseNumber:1:=app_AutoIncrement(->[Customers_ReleaseSchedules:46])
[Customers_ReleaseSchedules:46]OrderNumber:2:=[Customers_Order_Lines:41]OrderNumber:1
[Customers_ReleaseSchedules:46]OrderLine:4:=[Customers_Order_Lines:41]OrderLine:3
[Customers_ReleaseSchedules:46]Shipto:10:=[Customers_Order_Lines:41]defaultShipTo:17
[Customers_ReleaseSchedules:46]Billto:22:=[Customers_Order_Lines:41]defaultBillto:23
[Customers_ReleaseSchedules:46]ProductCode:11:=[Customers_Order_Lines:41]ProductCode:5
[Customers_ReleaseSchedules:46]CustID:12:=[Customers_Order_Lines:41]CustID:4
[Customers_ReleaseSchedules:46]CustomerRefer:3:=[Customers_Order_Lines:41]PONumber:21
[Customers_ReleaseSchedules:46]CustomerLine:28:=[Customers_Order_Lines:41]CustomerLine:42  //•060295  MLB  UPR 184
[Customers_ReleaseSchedules:46]ModDate:18:=4D_Current_date
[Customers_ReleaseSchedules:46]ModWho:19:=<>zResp
[Customers_ReleaseSchedules:46]PayU:31:=Num:C11([Customers_Order_Lines:41]PayUse:47)  //•101095  MLB 
[Customers_ReleaseSchedules:46]Entered_Date:34:=4D_Current_date
[Customers_ReleaseSchedules:46]THC_State:39:=9  //•102297  MLB  was, -4, chg so it show up as not being processed yet
[Customers_ReleaseSchedules:46]ProjectNumber:40:=[Customers_Order_Lines:41]ProjectNumber:50

SAVE RECORD:C53([Customers_ReleaseSchedules:46])
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	ADD TO SET:C119([Customers_ReleaseSchedules:46]; "currentRels")
	
	
Else 
	
	APPEND TO ARRAY:C911($_currentRels; Record number:C243([Customers_ReleaseSchedules:46]))
	
	
End if   // END 4D Professional Services : January 2019 
pattern_PassThru(->[Customers_ReleaseSchedules:46])
UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])
ViewSetter(2; ->[Customers_ReleaseSchedules:46])
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	USE SET:C118("currentRels")
	CLEAR SET:C117("currentRels")
	
	
Else 
	
	CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; $_currentRels)
	
	
End if   // END 4D Professional Services : January 2019 
ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
//