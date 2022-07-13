Case of 
	: (In header:C112)
		C_PICTURE:C286(pPicture; <>pNullPict)
		pPicture:=<>pNullPict
		dDate:=4D_Current_date
		
		If (Printing page:C275=1)
			If ([Purchase_Orders:11]PurchaseApprv:44)
				If (showSignature)  //if the user has NOT been authorized to print POs with a Signutre
					
					If (Current user:C182="Designer")
						QUERY:C277([Users:5]; [Users:5]Initials:1="LXS")
					Else 
						QUERY:C277([Users:5]; [Users:5]Initials:1=[Purchase_Orders:11]ApprovedBy:26)
					End if 
					If (Records in selection:C76([Users:5])>0)
						pPicture:=[Users:5]Signature:13
						REDUCE SELECTION:C351([Users:5]; 0)
					End if 
				End if 
			End if 
			
			RELATE MANY:C262([Purchase_Orders:11]PONo:1)
			ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; >)
			
			If ([Purchase_Orders:11]LastChgOrdDate:19#!00-00-00!)
				aCode:=String:C10([Purchase_Orders:11]LastChgOrdDate:19)
			Else 
				aCode:=""
			End if 
		End if 
End case 
//