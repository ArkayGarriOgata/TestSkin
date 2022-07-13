// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 10/11/13, 14:57:49
// ----------------------------------------------------
// Object Method: [zz_control].FGTranfers.sJobit
// Description:
// Searches for the correct records based on a JobIt.
// ----------------------------------------------------

If (Length:C16(sJobit)=11)
	i1:=Num:C11(Substring:C12(sJobit; 10))  //Keep these two for use downline.
	sCriterion5:=Substring:C12(sJobit; 1; 8)
	$numJMI:=qryJMI(sJobit)
	
	Case of 
		: ($numJMI=0)
			Case of 
				: (iMode=4)  //scrap, allow for purged jobs
					BEEP:C151  //punish the user, just kidding!
					BEEP:C151
					sCriterion1:=""
					GOTO OBJECT:C206(sCriterion1)
					
				Else 
					BEEP:C151
					uConfirm(String:C10(i1)+" is not a valid item on job form "+sCriterion5; "Ok"; "Help")
					i1:=0
					sJobit:=""
					sCriterion1:=""
					sCriterion2:="00000"
					sCriterion6:="00000.00"
					GOTO OBJECT:C206(sJobit)
			End case   //none found                
			
		: ($numJMI>=1)  //•101398  MLB  handle multiples at Posting
			sCriterion6:=[Job_Forms_Items:44]OrderItem:2
			sCriterion1:=[Job_Forms_Items:44]ProductCode:3
			
			asCriter2{1}:=[Job_Forms_Items:44]CustId:15
			asCriter2:=1
			sCriterion2:=asCriter2{asCriter2}
			
			If (iMode=2)  //receipt
				GOTO OBJECT:C206(rReal1)
			End if 
			
	End case 
	
	If (sCriterion6#"") & (sCriterion6#"00000.00") & (sCriterion6#"DF@")
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=sCriterion6; *)
		QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]ProductCode:5=sCriterion1)
		If (Records in selection:C76([Customers_Order_Lines:41])=0)
			BEEP:C151
			uConfirm(sCriterion1+" was not found on order item "+sCriterion6; "Ok"; "Help")
			sCriterion6:="00000.00"
			
		Else 
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
		End if 
		GOTO OBJECT:C206(rReal1)
	End if 
	
Else 
	uConfirm("Enter a Jobform first in the format '12345.12.12'."; "Ok"; "Help")
	i1:=0
	sJobit:=""
	GOTO OBJECT:C206(sJobit)
End if 