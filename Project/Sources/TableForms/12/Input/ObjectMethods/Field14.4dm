// ----------------------------------------------------
// User name (OS): cs
// Date: 5/12/98
// ----------------------------------------------------
// Object Method: [Purchase_Orders_Items].Input.Field14
// ----------------------------------------------------

If ([Purchase_Orders_Items:12]Canceled:44)
	If ([Purchase_Orders_Items:12]Qty_Received:14=0)
		Core_ObjectSetColor(->[Purchase_Orders_Items:12]Canceled:44; -3)  //make background red and forground 
		[Purchase_Orders_Items:12]ExpeditingNote:23:="•Cancelled•"+Char:C90(13)+[Purchase_Orders_Items:12]ExpeditingNote:23
		[Purchase_Orders:11]Comments:21:="•Item "+[Purchase_Orders_Items:12]ItemNo:3+" Cancelled•"+Char:C90(13)+[Purchase_Orders:11]Comments:21
		[Purchase_Orders_Items:12]Qty_Open:27:=0
		[Purchase_Orders_Items:12]Qty_Ordered:30:=0
		CalcPOitem
		
		SetObjectProperties("tcancelled"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/17/13)
		
	Else 
		uConfirm("PO Items, which have reveiving quantities agaist them MAY NOT be cancelled."+Char:C90(13)+"To cancel an Item have the material(s) returned, then cancel."; "OK"; "Help")
		[Purchase_Orders_Items:12]Canceled:44:=False:C215
	End if 
	
Else 
	Core_ObjectSetColor(->[Purchase_Orders_Items:12]Canceled:44; -15)  //make normal colors - blac
	[Purchase_Orders_Items:12]ExpeditingNote:23:=Replace string:C233([Purchase_Orders_Items:12]ExpeditingNote:23; "•Cancelled•"+Char:C90(13); "")
	[Purchase_Orders:11]Comments:21:=Replace string:C233([Purchase_Orders:11]Comments:21; "•Item "+[Purchase_Orders_Items:12]ItemNo:3+" Cancelled•"+Char:C90(13); "")
	uConfirm("You will need to reset the quantity ordered."; "OK"; "Help")
	SetObjectProperties("tcancelled"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/17/13)
End if 