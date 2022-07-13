//%attributes = {"publishedWeb":true}
//(p) ReqPrint
//• 6/10/97 cs created

Case of 
	: (Count parameters:C259=0) & (Records in set:C195("UserSet")=0)  //called from listing - no user selection
		uConfirm("You Need to Select (highlight) one or more records to print."; "OK"; "Help")
		$Continue:=False:C215  //do not print
		
	: (Count parameters:C259=0)  //called from listing
		If (Not:C34(<>modification4D_25_03_19)) | (<>disable_4DPS_mod)  // Modified by: Mel Bohince (4/17/19) // BEGIN 4D Professional Services : Set final step
			
			COPY NAMED SELECTION:C331([Purchase_Orders:11]; "ReqInHand")  //copy current POs/Reqs
			
			
		Else 
			
			ARRAY LONGINT:C221($_ReqInHand; 0)
			LONGINT ARRAY FROM SELECTION:C647([Purchase_Orders:11]; $_ReqInHand)
			
		End if   // END 4D Professional Services : January 2019 
		USE SET:C118("UserSet")  //make the ones to print current
		CLEAR SET:C117("UserSet")
		$Continue:=True:C214  //OK to print
		
	Else   //called from inside a single PO/Req
		SAVE RECORD:C53([Purchase_Orders:11])  //since we are inside a record insure that changes are not lost
		If (Not:C34(<>modification4D_25_03_19)) | (<>disable_4DPS_mod)  // Modified by: Mel Bohince (4/17/19)  // BEGIN 4D Professional Services : Set final step
			
			COPY NAMED SELECTION:C331([Purchase_Orders:11]; "ReqInHand")
			
		Else 
			
			ARRAY LONGINT:C221($_ReqInHand; 0)
			LONGINT ARRAY FROM SELECTION:C647([Purchase_Orders:11]; $_ReqInHand)
			
			
		End if   // END 4D Professional Services : January 2019 
		
		ONE RECORD SELECT:C189([Purchase_Orders:11])  //make it the only one
		$Continue:=True:C214
End case 

If ($Continue)  //OK to print
	MESSAGES OFF:C175  //turn off messages there is a sort in printing 
	util_PAGE_SETUP(->[Purchase_Orders:11]; "RequisitionForm")
	PRINT SETTINGS:C106  //ask user to confirm printing
	
	If (OK=1)  //user wants to print
		FORM SET OUTPUT:C54([Purchase_Orders:11]; "RequisitionForm")
		PRINT SELECTION:C60([Purchase_Orders:11]; *)
		FORM SET OUTPUT:C54([Purchase_Orders:11]; "ReqList")  //reset output layout
	End if 
	If (Not:C34(<>modification4D_25_03_19)) | (<>disable_4DPS_mod)  // Modified by: Mel Bohince (4/17/19)  // BEGIN 4D Professional Services : Set final step
		// Modified by: Mel Bohince (4/17/19) 
		USE NAMED SELECTION:C332("ReqInHand")  //return selection
		CLEAR NAMED SELECTION:C333("ReqInHand")  //clear
		
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Purchase_Orders:11]; $_ReqInHand)
		
	End if   // END 4D Professional Services : January 2019 
	MESSAGES ON:C181
End if 