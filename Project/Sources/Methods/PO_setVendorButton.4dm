//%attributes = {}
// _______
// Method: PO_setVendorButton   ( ) ->
// By: Mel Bohince @ 05/15/20, 13:41:43
// Description
// manage the state of choose vendor button
// ----------------------------------------------------

If ([Purchase_Orders:11]VendorID:2#"")  //(S) [PURCHASE_ORDER]Input'VendorID
	OBJECT SET TITLE:C194(*; "VendorButton"; "Update Vendor")
	
Else 
	REDUCE SELECTION:C351([Vendors:7]; 0)
	OBJECT SET TITLE:C194(*; "VendorButton"; "Choose Vendor")
	textAddress:="Enter or choose a vendor."
End if 


