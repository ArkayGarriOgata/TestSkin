If (rb1=1)
	If (Num:C11(sCriterion1)#0)
		sCriterion1:=nZeroFill(Replace string:C233(sCriterion1; " "; ""); 7)
		QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=sCriterion1; *)
		QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]PurchaseApprv:44=True:C214)
		If (Records in selection:C76([Purchase_Orders:11])=1)
			ADD TO SET:C119([Purchase_Orders:11]; "printThese")
			t1:=t1+sCriterion1+Char:C90(13)
		Else 
			BEEP:C151
			ALERT:C41(sCriterion1+" was not found or not approved.")
		End if 
		
		sCriterion1:=""
		REJECT:C38  // get another 
		GOTO OBJECT:C206(sCriterion1)
		
	End if 
End if 