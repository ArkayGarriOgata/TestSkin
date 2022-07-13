//%attributes = {"publishedWeb":true}
//(p) PoAcctReview
//allow (Carol Irvolino) accounting dept to easily view (in order selected) 
//POs to review status with regard to paymant/receipt quantities
//• 3/16/98 cs created
//• 3/24/98 cs forgot to set input layout
// Modified by: MelvinBohince (1/19/22) prevent PO and Vendor locking

C_LONGINT:C283(Po1)

<>filePtr:=->[Purchase_Orders:11]
fAdHoc:=False:C215  //flag for entry screens, 3/24/95
uSetUp(1; 1)
gClearFlags
CREATE SET:C116(filePtr->; "CurrentSet")
fRev:=True:C214
READ ONLY:C145(filePtr->)

If (Count parameters:C259=0)  // pallete  
	READ ONLY:C145([Purchase_Orders:11])  // Modified by: MelvinBohince (1/19/22) was rw
	READ ONLY:C145([Purchase_Orders_Items:12])  // Modified by: MelvinBohince (1/19/22)  rw
	READ ONLY:C145([Vendors:7])  // added by: MelvinBohince (1/19/22) 
	READ ONLY:C145([Purchase_Orders_Job_forms:59])
	READ ONLY:C145([Raw_Materials_Transactions:23])
	READ ONLY:C145([Users:5])
	DEFAULT TABLE:C46([Purchase_Orders:11])
	uDialog("SelectPO2Review"; 310; 195; 4; "Select POs to Review")
End if 

If (OK=1)
	FORM SET INPUT:C55([Purchase_Orders:11]; "AcctReview")
	Po1:=1
	NewWindow(830; 560; 2; 8; "Review Purchase Orders")
	
	Repeat 
		DISPLAY SELECTION:C59([Purchase_Orders:11])
	Until (OK=0)
	ARRAY TEXT:C222(aText; 0)
	uClearSelection(->[Purchase_Orders:11])
	uClearSelection(->[Purchase_Orders_Items:12])
	uClearSelection(->[Purchase_Orders_Job_forms:59])
	uClearSelection(->[Raw_Materials_Transactions:23])
	uClearSelection(->[Users:5])
	FORM SET INPUT:C55([Purchase_Orders:11]; "Input")
End if 

uWinListCleanup