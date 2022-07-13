// ----------------------------------------------------
// Object Method: [zz_control].FGTranfers.Variable7
// ----------------------------------------------------

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=Num:C11(sCriter12))
If (Records in selection:C76([Customers_ReleaseSchedules:46])=1)
	ARRAY TEXT:C222(asCriter2; 1)
	
	sCriterion1:=[Customers_ReleaseSchedules:46]ProductCode:11
	asCriter2{1}:=[Customers_ReleaseSchedules:46]CustID:12
	asCriter2:=1
	sCriterion2:=asCriter2{asCriter2}
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Customers_ReleaseSchedules:46]OrderLine:4)
	If (Records in selection:C76([Customers_Order_Lines:41])=1)
		sCriterion6:=[Customers_Order_Lines:41]OrderLine:3
		If ([Customers_Order_Lines:41]ProductCode:5#[Customers_ReleaseSchedules:46]ProductCode:11)
			BEEP:C151
			ALERT:C41("Release CPN does not match the orderlines CPN.")
		End if 
		
	End if 
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2=sCriterion6; *)
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=sCriterion1)
	If (Records in selection:C76([Job_Forms_Items:44])>0)
		sCriterion5:=[Job_Forms_Items:44]JobForm:1
		i1:=[Job_Forms_Items:44]ItemNumber:7
	Else 
		BEEP:C151
		sCriterion5:="00000.00"
		GOTO OBJECT:C206(sCriterion5)
		i1:=0
	End if 
	SetObjectProperties(""; ->sCriterion5; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/14/13)
Else 
	BEEP:C151
	ALERT:C41("That release number was not found.")
End if 