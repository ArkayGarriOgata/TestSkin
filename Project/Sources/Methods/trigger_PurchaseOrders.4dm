//%attributes = {}
// _______
// Method: trigger_PurchaseOrders   ( ) ->
// By: Garri Ogata @ 05/13/22, 11:05 AM
// Description
// 
// ----------------------------------------------------

C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		
		[Purchase_Orders:11]VendorName:42:=Vndr_GetNameT([Purchase_Orders:11]VendorID:2)
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		
		[Purchase_Orders:11]VendorName:42:=Vndr_GetNameT([Purchase_Orders:11]VendorID:2)
		
End case 