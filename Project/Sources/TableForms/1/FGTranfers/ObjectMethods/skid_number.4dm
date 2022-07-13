// _______
// Method: [zz_control].FGTranfers.skid_number   ( ) ->
// By: Mel Bohince @ 09/05/19, 16:41:19
// Description
// 
// ----------------------------------------------------

Case of 
	: (iMode=0)  //move
		$numRecs:=FGL_findBySkid(sCriter10; "reset")
		If ($numRecs=0)
			sCriterion1:=sCriter10+" was not found, try again."
			sCriter10:=""
			qtyBeforeAdj:=0
			GOTO OBJECT:C206(sCriter10)
			
		Else 
			qtyBeforeAdj:=rReal1
		End if 
		
	: (iMode=2)  //receipt
		If (wms_itemExists(sCriter10))
			If (rReal1>0)
				uConfirm("Cannot receive the same skid twice!"; "Try again"; "Reverse")
				If (ok=1)
					sCriter10:=""
				Else 
					rReal1:=rReal1*-1
				End if 
				GOTO OBJECT:C206(sCriter10)
			End if 
			
		Else 
			$numRecs:=FGL_findBySkid(sCriter10)
			If ($numRecs=0)
				sCriter10:=""
				GOTO OBJECT:C206(sCriter10)
			End if 
			
			asCriter2:=1
			sCriterion2:=asCriter2{asCriter2}
			
			If (sCriterion6#"") & (sCriterion6#"00000.00") & (sCriterion6#"DF@")
				
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=sCriterion6; *)
				QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]ProductCode:5=sCriterion1)
				If (Records in selection:C76([Customers_Order_Lines:41])=0)
					BEEP:C151
					ALERT:C41(sCriterion1+" was not found on order item "+sCriterion6)
					sCriterion6:="00000.00"
					//GOTO AREA(sCriterion6)
				End if 
				
			End if 
		End if 
		
End case 
