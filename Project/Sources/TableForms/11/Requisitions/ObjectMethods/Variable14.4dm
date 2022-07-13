//(s) [purchaseorder]requistion'bPrint
uConfirm("Printing the Requisiton will save your changes."+Char:C90(13)+"Is this what you want to do?")
If (OK=1)  //user agreed
	
	If (ReqAcceptScrpt)
		ReqAfter
		SAVE RECORD:C53([Purchase_Orders:11])
		
		//If ([Purchase_Orders]NewVendor)
		//CREATE RECORD()
		//  `ReqGetNewVendor   `saves data from vars to fields
		//SAVE RECORD()
		//End if 
		ReqPrint([Purchase_Orders:11]PONo:1)  //print
		ACCEPT:C269
		
	Else 
		BEEP:C151
		ALERT:C41("Fix the problems before printing")
	End if 
	
End if 
//