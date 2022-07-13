//%attributes = {}
// Method: CCO_validateChanges () -> 
// ----------------------------------------------------
// by: mel: 11/04/04, 12:09:53
// ----------------------------------------------------
// Description:
// so button script can reject an Accept action
// ----------------------------------------------------
//• 9/23/97 cs check on item changes ONLY if status is 'proceeding...'

C_LONGINT:C283($TooMany)
C_BOOLEAN:C305($accept)

$accept:=True:C214

Case of 
	: (Not:C34(Modified record:C314([Customers_Order_Change_Orders:34])))
	: ([Customers_Order_Change_Orders:34]AddOrDeleteItem:13)  //
	: ([Customers_Order_Change_Orders:34]BillTo:29)
	: ([Customers_Order_Change_Orders:34]Cancel_:32)  //
	: ([Customers_Order_Change_Orders:34]ContinueWith:33)
	: ([Customers_Order_Change_Orders:34]ContinueWithout:34)
	: ([Customers_Order_Change_Orders:34]CPNchg:10)
	: ([Customers_Order_Change_Orders:34]FOB_point:25)
	: ([Customers_Order_Change_Orders:34]GraphicChg:12)  //
	: ([Customers_Order_Change_Orders:34]HoldOtherReason:31)  //
	: ([Customers_Order_Change_Orders:34]PO_NumberChg:22)
	: ([Customers_Order_Change_Orders:34]PriceChg:21)
	: ([Customers_Order_Change_Orders:34]ProcessChg:9)  //
	: ([Customers_Order_Change_Orders:34]QtyChg:8)  //
	: ([Customers_Order_Change_Orders:34]ReleaseDate:26)
	: ([Customers_Order_Change_Orders:34]ReleaseQty:27)
	: ([Customers_Order_Change_Orders:34]ShipTo:28)
	: ([Customers_Order_Change_Orders:34]SizeChg:7)  //
	: ([Customers_Order_Change_Orders:34]SpecialServiceC:11)  //
	Else 
		BEEP:C151
		ALERT:C41("You must tick a checkbox with the reason for this change order.")
		$accept:=False:C215
End case 

//(s) HaFgis (accept button) on Change order history input (page 1 & 2)
//fonlyOne set in before of the layout
//• 5/22/97 cs created upr 1882
If (fOnlyOne)
	If (Position:C15("Proceed"; [Customers_Order_Change_Orders:34]ChgOrderStatus:20)>0)  //• 9/23/97 cs only check if the change order is not going to be 'in limbo'
		$TooMany:=CCOChkForChange  //test the oderchange lines for multiple changes
		If ($TooMany#-1)  //if changes OK
			ALERT:C41("You have changed BOTH the quantity & Price on one or more orderlines."+Char:C90(13)+"Orderline number "+String:C10($TooMany)+Char:C90(13)+"Since this order has started shipping this is NOT allowed."+Char:C90(13)+"To make multiple changes to one item, create multiple CCOs.")
			$accept:=False:C215
		End if 
	End if 
End if 

$0:=$accept