//(s) [purchaseorder]requistion'bPrint
uConfirm("Printing the RFQ will save your changes."+Char:C90(13)+"Is this what you want to do?")
If (OK=1)  //user agreed
	
	If (ReqAcceptScrpt)
		ReqAfter
		SAVE RECORD:C53([Purchase_Orders:11])
		
		//If ([Purchase_Orders]NewVendor)
		//CREATE RECORD()
		//  `ReqGetNewVendor   `saves data from vars to fields
		//SAVE RECORD()
		//End if 
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
			
			COPY NAMED SELECTION:C331([Purchase_Orders:11]; "ReqInHand")
			
		Else 
			
			ARRAY LONGINT:C221($_ReqInHand; 0)
			LONGINT ARRAY FROM SELECTION:C647([Purchase_Orders:11]; $_ReqInHand)
			
			
		End if   // END 4D Professional Services : January 2019 
		
		ONE RECORD SELECT:C189([Purchase_Orders:11])  //make it the only one
		
		
		MESSAGES OFF:C175  //turn off messages there is a sort in printing 
		util_PAGE_SETUP(->[Purchase_Orders:11]; "RFQform")
		PRINT SETTINGS:C106  //ask user to confirm printing
		
		If (OK=1)  //user wants to print
			FORM SET OUTPUT:C54([Purchase_Orders:11]; "RFQform")
			PRINT SELECTION:C60([Purchase_Orders:11]; *)
			FORM SET OUTPUT:C54([Purchase_Orders:11]; "ReqList")  //reset output layout
		End if 
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
			
			USE NAMED SELECTION:C332("ReqInHand")  //return selection
			CLEAR NAMED SELECTION:C333("ReqInHand")  //clear
			
			
		Else 
			
			CREATE SELECTION FROM ARRAY:C640([Purchase_Orders:11]; $_ReqInHand)
			
		End if   // END 4D Professional Services : January 2019 
		MESSAGES ON:C181
		
		ACCEPT:C269
		
	Else 
		BEEP:C151
		ALERT:C41("Fix the problems before printing")
	End if 
	
End if 
//