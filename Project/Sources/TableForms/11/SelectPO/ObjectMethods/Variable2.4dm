//(S) [PURCHASE_ORDER]'SelectPO'bOK
TRACE:C157
C_LONGINT:C283($recs)
Case of 
	: (rb1=1)
		If (Num:C11(sCriterion1)#0)
			sCriterion1:=nZeroFill(Replace string:C233(sCriterion1; " "; ""); 7)
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=sCriterion1; *)
			QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]PurchaseApprv:44=True:C214)
			If (Records in selection:C76([Purchase_Orders:11])=1)
				ADD TO SET:C119([Purchase_Orders:11]; "printThese")
				t1:=t1+sCriterion1+Char:C90(13)
			Else 
				BEEP:C151
				ALERT:C41(sCriterion1+" was not found or not Approved.")
			End if 
			
			sCriterion1:=""
			REJECT:C38  // get another 
		Else 
			USE SET:C118("printThese")
			//   CLEAR SET("printThese")`• 3/6/98 cs removed
		End if 
		//    
	: (rb2=1)
		QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PODate:4=dDate; *)
		QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]PurchaseApprv:44=True:C214)
		
	: (rb3=1)
		QUERY:C277([Purchase_Orders:11])
		
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]PurchaseApprv:44=True:C214)
		
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
		
End case 
//TRACE


$recs:=Records in selection:C76([Purchase_Orders:11])
Case of 
	: (OK=0)
		REJECT:C38
	: ($recs=0) & (OK=1)
		BEEP:C151
		ALERT:C41("No Approved PO's were found using your criteria!"+Char:C90(13)+Char:C90(13)+"Please try again.")
		REJECT:C38
	: (rb1=1)
	: (rb2=1)
	: (rb3=1)
	: ($recs>1) & (OK=1)
		BEEP:C151
		CONFIRM:C162("Ready to print "+String:C10($recs)+" Purchase Orders!")
		If (ok=0)
			REJECT:C38
		End if 
	Else 
		REJECT:C38
End case 
//EOS