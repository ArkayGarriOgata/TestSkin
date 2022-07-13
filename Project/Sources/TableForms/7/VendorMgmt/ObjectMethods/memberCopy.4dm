// _______
// Method: [Vendors].VendorMgmt.memberCopy   ( ) ->
// By: Mel Bohince @ 05/11/20, 14:18:34
// Description
// 
// ----------------------------------------------------


If (Form:C1466.position>0)
	$vendorID:=Form:C1466.editEntity.ID
	SET TEXT TO PASTEBOARD:C523($vendorID)
	zwStatusMsg("COPIED"; "Vendor ID "+$vendorID+" is ready to Paste")
	CANCEL:C270
	
Else 
	uConfirm("Select a vendor to copy/paste."; "Ok"; "Help")
End if 