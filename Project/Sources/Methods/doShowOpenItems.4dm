//%attributes = {"publishedWeb":true}
//called by open itme button on poevent layout

<>iMode:=3
<>filePtr:=->[Purchase_Orders_Items:12]

FORM SET INPUT:C55([Purchase_Orders_Items:12]; "Input")
FORM SET OUTPUT:C54([Purchase_Orders_Items:12]; "List")
uSetUp(1; 1)  // doReviewRecord()
gClearFlags
CREATE SET:C116(filePtr->; "CurrentSet")
fRev:=True:C214
READ ONLY:C145(filePtr->)

//CONFIRM("Hide Open INX Ink POs?";"Hide";"Show")
//If (OK=1)
//QUERY([Purchase_Orders_Items];[Purchase_Orders_Items]Qty_Open>0;*)
//QUERY([Purchase_Orders_Items]; & ;[Purchase_Orders_Items]Canceled=False)
//CREATE SET([Purchase_Orders_Items];"Open_POs")
//QUERY([Purchase_Orders];[Purchase_Orders]INX_autoPO=True)
//RELATE MANY SELECTION([Purchase_Orders_Items]PONo)
//CREATE SET([Purchase_Orders_Items];"INX_POs")
//DIFFERENCE("Open_POs";"INX_POs";"Open_POs")
//USE SET("Open_POs")
//CLEAR SET("Open_POs")
//CLEAR SET("INX_POs")
//Else 
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]Qty_Open:27>0; *)
QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]Canceled:44=False:C215)
//End if 

If (Records in selection:C76([Purchase_Orders_Items:12])>0)
	Repeat 
		CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
		Open window:C153(2; 40; 508; 338; 8; fNameWindow(filePtr)+" Open PO Items")  //;"wCloseWinBox")
		DISPLAY SELECTION:C59([Purchase_Orders_Items:12]; *)
	Until (bDone=1) | (OK=0)
	CLOSE WINDOW:C154
Else 
	BEEP:C151
	ALERT:C41("No PO Items with open quantities were found.")
End if 
uSetUp(0; 0)