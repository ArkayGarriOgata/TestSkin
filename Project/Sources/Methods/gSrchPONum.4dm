//%attributes = {"publishedWeb":true}
//(P)gSrchPONum
//1/23/95 array sorting problem
//• 1/13/97 upr 0235 - cs - better selection of default location
//• 6/20/97 cs added display of who/department order item is for
//• 11/4/97 cs insure that rqty2 is set corrrectly
//• 3/5/98 cs Found hole in system - if material(s) were ordered and PO NOT aprvd
//  it was possible to recieve material(s) with out an approved PO - fixed
//• 4/24/98 cs instituted canceling an item - do not display for receipt
//• 4/30/98 cs autogen of receiving number

C_TEXT:C284(xText2)
C_TEXT:C284(sReceiveNum)

gClrRMFields

SetObjectProperties(""; ->rQty2; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
POI_ItemsToReceive(0)
READ ONLY:C145([Purchase_Orders:11])
READ ONLY:C145([Purchase_Orders_Items:12])

QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=sPONum)

If (Records in selection:C76([Purchase_Orders:11])=1)  //• 3/5/98 cs insure that only one PO found
	If ([Purchase_Orders:11]PurchaseApprv:44)  //• 3/5/98 cs insure that PO was approved BEFORE receiving is allowed to accept it
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PONo:2=sPONum; *)
		QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]Canceled:44=False:C215)  //• 4/24/98 cs do not display canceled items
		If (Records in selection:C76([Purchase_Orders_Items:12])>0)
			POI_ItemsToReceive(0; "Load")
			gSelectPOItem  //2/9/95
			LISTBOX SELECT ROW:C912(abSelectLB; 1)  // Added by: Mark Zinke (9/30/13) 
			
		Else 
			uConfirm("No PO Items exist for this PO# "+sPONum+"."; "Try Again"; "OK")
			sPONum:=""
			GOTO OBJECT:C206(sPoNum)
		End if 
		
	Else 
		uConfirm("PO# "+sPoNum+" was never approved."+Char:C90(13)+"All PO's MUST be Approved before materials can be received."+Char:C90(13)+"Please talk to someone in the Purchasing department about this problem."; "Try Again"; "Help")
		sPONum:=""
		GOTO OBJECT:C206(sPoNum)
	End if 
	
Else 
	uConfirm("PO# "+sPONum+" was not found."; "Try Again"; "Help")
	sPONum:=""
	GOTO OBJECT:C206(sPONum)
End if 