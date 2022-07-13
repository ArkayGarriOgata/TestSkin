// Modified by: Mel Bohince (11/13/15) 
pendingChange:=pendingChange+"Underrun Changed from "+String:C10(Old:C35([Customers_Order_Lines:41]UnderRun:26))+" to "+String:C10([Customers_Order_Lines:41]UnderRun:26)+Char:C90(Carriage return:K15:38)
If ([Customers_Orders:40]Status:10="Open@")  //UPR 1188 02/13/ 95 chip
	READ WRITE:C146([Estimates_Carton_Specs:19])
	QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]CartonSpecKey:7=[Customers_Order_Lines:41]CartonSpecKey:19)
	
	If (Records in selection:C76([Estimates_Carton_Specs:19])=1)
		If (fLockNLoad(->[Estimates_Carton_Specs:19]))
			[Estimates_Carton_Specs:19]UnderRun:48:=Self:C308->
			SAVE RECORD:C53([Estimates_Carton_Specs:19])
		End if 
	End if 
	
	REDUCE SELECTION:C351([Estimates_Carton_Specs:19]; 0)
Else 
	uConfirm("Status of this Customer Order is NOT 'OPEN', Changes Made to Over/Under Runs"+" Will NOT be Passed Back to the Originating Estimate."; "OK"; "Help")
End if 