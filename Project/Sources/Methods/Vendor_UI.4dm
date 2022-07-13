//%attributes = {}
// _______
// Method: Vendor_UI   ( ) ->
// By: Mel Bohince @ 04/20/20, 11:36:06
// Description
// open a list of vendors
// ----------------------------------------------------
//* see also:
//app_form_Button
//app_form_Detail
//app_form_ListBox
//app_form_Mgmt
//app_form_Notice_Text
//app_form_Open
//app_form_Refresh
//app_form_Save_touched
//*/

C_LONGINT:C283($1; $pid)

If (Count parameters:C259=0)
	$pid:=New process:C317(Current method name:C684; 0; Current method name:C684; 1; *)
	SHOW PROCESS:C325($pid)
	
Else 
	C_OBJECT:C1216($form_o)
	
	$form_o:=New object:C1471
	//now customize parameters
	$form_o.masterClass:=ds:C1482.Vendors
	$form_o.masterTable:=Table:C252(->[Vendors:7])  // Modified by: Mel Bohince (4/18/20) can't use a pointer in the attribute
	$form_o.baseForm:="VendorMgmt"  //the two page listbox + detail form
	$form_o.detailForm:="VendorDetail"  //the one page detail form when doing the "Open Multiple"
	$form_o.listBoxEntities:=New object:C1471  //this will be selection that the listbox uses
	$form_o.editEntity:=New object:C1471  //this will be the entity shown on the detail form
	$form_o.parentForm:=0  //used to callback to the listbox when in multiwindow mode has changes
	$form_o.deleteAction:="Deactivate"  // or "delete" if you want the record deleted on user's perogative
	C_COLLECTION:C1488($noticeFields_c)
	$noticeFields_c:=New collection:C1472("ID"; "Name")  // field(s) to be used by delete to confirm the record
	$form_o.noticeText_c:=$noticeFields_c
	//any time that the listbox selection is to be init'd
	$form_o.defaultQuery:=New object:C1471("criteria"; "Name = :1 "; "value"; "Name")
	$form_o.defaultOrderBy:="Name asc"
	//these are for the search box and the active button
	$form_o.searchBoxQueryActive:="Name = :1 OR DefaultAttn = :1 OR VendorType = :1 and Active = :2 "
	$form_o.searchBoxQueryInactive:="Name = :1 OR DefaultAttn = :1 OR VendorType = :1"
	//regarding the 'New' button:
	//specify which field is the table "id" holder to get incremented, if not in the trigger
	$form_o.idField:="ID"
	//see the New btn script if you want to customize any default values or use trigger
	
	//assign access membership that can make changes
	//this will disable the delete and save buttons, and the first/prev/next/last option to save if touched
	$form_o.editorGroup:="Vendors"
	
	app_form_Open($form_o)
	
End if 



