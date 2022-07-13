// _______
// Method: [Purchase_Orders].Input.VendorButton   ( ) ->
// ----------------------------------------------------
// User name (OS): cs  Date: 6/16/97

// Modified by: Mel Bohince (5/12/20) orda the vendor picking and displaying, eliminate bad grouped listbox
// ----------------------------------------------------

$holdTabControl:=iTabControl

If ([Purchase_Orders:11]VendorID:2#"")  //update vend record
	uConfirm("If you made changes to the Vendor you'll need to re-enter its ID"; "Ok"; "Help")
	C_LONGINT:C283($winRef; $parentWinRef)  // Modified by: Mel Bohince (5/12/20) orda the vendor picking and displaying
	$parentWinRef:=Current form window:C827  //for the call back
	
	$xy:=OpenFormWindowCoordinates("get")
	
	$winRef:=Open form window:C675([Vendors:7]; "VendorDetail"; Plain form window:K39:10; $xy.x; $xy.y)
	
	C_OBJECT:C1216($form_o)  //give the child some parental advice
	$form_o:=New object:C1471
	$form_o.list:=ds:C1482.Vendors.query("ID = :1"; [Purchase_Orders:11]VendorID:2)
	$form_o.ent:=$form_o.list.first()
	$form_o.listPosition:=1
	$form_o.deleteAction:="Deactivate"  // or "delete" if you want the record deleted on user's perogative
	$form_o.noticeText_c:=New collection:C1472("ID"; "Name")  // field(s) to be used by delete to confirm the record
	$form_o.noticeText:="Vendor "+[Purchase_Orders:11]VendorName:42  //give the child form its own copy of this
	$form_o.editorGroup:="Vendors"
	$form_o.parentForm:=-1  //skip call back is changes are saved
	
	DIALOG:C40([Vendors:7]; "VendorDetail"; $form_o; *)
	
Else   //pickone
	C_OBJECT:C1216($vend_o)  // Modified by: Mel Bohince (5/12/20) orda the vendor picking and displaying
	$vend_o:=util_PickOne_UI(ds:C1482.Vendors.query("Active = :1"; True:C214); "Name"; ->[Vendors:7])  //rtn is a shallow obj, 3rd param loads the record
	//was: uLookup (->[Vendors]Name;->[Purchase_Orders]VendorName;->[Vendors]ID;->[Purchase_Orders]VendorID;->[Vendors]DefaultAttn;->[Purchase_Orders]AttentionOf;->[Vendors]Std_Terms;->[Purchase_Orders]Terms;->[Vendors]ShipVia;->[Purchase_Orders]ShipVia;->[Vendors]FOB;->[Purchase_Orders]FOB;->[Vendors]Std_Discount;->[Purchase_Orders]Std_Discount)
	PoVendorAssign
End if 

PO_setVendorButton

iTabControl:=$holdTabControl