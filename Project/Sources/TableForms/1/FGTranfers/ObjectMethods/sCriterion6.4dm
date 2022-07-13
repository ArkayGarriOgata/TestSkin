READ WRITE:C146([Customers_Order_Lines:41])
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=sCriterion6)
//SEARCH([OrderLines]; & [OrderLines]ProductCode=sCriterion1)
Case of 
	: (Records in selection:C76([Customers_Order_Lines:41])=0)
		BEEP:C151
		ALERT:C41(sCriterion6+" is not a valid order item ")
		sCriterion6:="00000.00"
		GOTO OBJECT:C206(sCriterion6)
		
	: (Records in selection:C76([Customers_Order_Lines:41])=1) & (fLockNLoad(->[Customers_Order_Lines:41]))
		If (sCriterion1#"")
			If (sCriterion1#[Customers_Order_Lines:41]ProductCode:5)
				BEEP:C151
				ALERT:C41(sCriterion1+" was not found on order item "+sCriterion6)
				sCriterion6:="00000.00"
				GOTO OBJECT:C206(sCriterion6)
			End if 
		Else 
			sCriterion1:=[Customers_Order_Lines:41]ProductCode:5
			ARRAY TEXT:C222(asCriter2; 1)
			asCriter2{1}:=[Customers_Order_Lines:41]CustID:4
			asCriter2:=1
			sCriterion2:=asCriter2{asCriter2}
		End if 
		
		
		
		If (Records in selection:C76([Job_Forms_Items:44])=1)
			If ([Job_Forms_Items:44]OrderItem:2#sCriterion6)
				BEEP:C151
				ALERT:C41("Warning: This job item was not produced for this order item.")
			End if 
		End if 
		
		If (iMode=5)
			If (Not:C34(ADDR_isValid([Customers_Order_Lines:41]defaultBillto:23)))  // Modified by: Mel Bohince (10/9/19) 
				uConfirm([Customers_Order_Lines:41]OrderLine:3+" does not appear to have a valid bill-to"; "Ok"; "Help")
				sCriterion6:=""
				EDIT ITEM:C870(sCriterion6)
				UNLOAD RECORD:C212([Customers_Order_Lines:41])
			End if 
			
			If (Not:C34(ADDR_isValid([Customers_Order_Lines:41]defaultShipTo:17)))  // Modified by: Mel Bohince (10/9/19) 
				uConfirm([Customers_Order_Lines:41]OrderLine:3+" does not appear to have a valid ship-to"; "Ok"; "Help")
				sCriterion6:=""
				EDIT ITEM:C870(sCriterion6)
				UNLOAD RECORD:C212([Customers_Order_Lines:41])
			End if 
			
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41(sCriterion6+" is not a unique order item ")
		sCriterion6:="00000.00"
		GOTO OBJECT:C206(sCriterion6)
End case 

//