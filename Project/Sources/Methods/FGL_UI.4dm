//%attributes = {}
// _______
// Method: FGL_UI   ( ) ->
// By: Mel Bohince @ 09/23/20, 14:08:37
// Description
// 
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

If (Count parameters:C259=0)  //setup singleton
	$pid:=New process:C317(Current method name:C684; 0; Current method name:C684; 1; *)
	SHOW PROCESS:C325($pid)
	
Else 
	C_BOOLEAN:C305(searchWidgetInited)
	searchWidgetInited:=False:C215
	
	C_OBJECT:C1216($form_o)
	//[Finished_Goods_Locations]
	//[Finished_Goods_Locations]skid_number
	
	$form_o:=New object:C1471
	//now customize parameters
	$form_o.masterClass:=ds:C1482.Finished_Goods_Locations
	$form_o.masterTable:=Table:C252(->[Finished_Goods_Locations:35])  // Modified by: Mel Bohince (4/18/20) can't use a pointer in the attribute
	$form_o.baseForm:="FGL_Mgmt"  //the two page listbox + detail form
	$form_o.detailForm:=""  //the one page detail form when doing the "Open Multiple"
	$form_o.listBoxEntities:=$form_o.masterClass.newSelection()
	$form_o.editEntity:=New object:C1471  //this will be the entity shown on the detail form
	$form_o.origEntity:=New object:C1471
	$form_o.parentForm:=0  //used to callback to the listbox when in multiwindow mode has changes
	$form_o.deleteAction:="delete"  // or "delete" if you want the record deleted on user's perogative
	C_COLLECTION:C1488($noticeFields_c)
	$noticeFields_c:=New collection:C1472("ProductCode"; "Jobit"; "skid_number"; "Location")  // field(s) to be used by delete to confirm the record
	$form_o.noticeText_c:=$noticeFields_c
	//any time that the listbox selection is to be init'd
	$form_o.defaultQuery:=New object:C1471("criteria"; "Jobit = :1 "; "value"; "Jobit")
	$form_o.defaultOrderBy:="Jobit asc, Location asc"
	//these are for the search box and the active button
	$form_o.searchBoxQueryActive:="Jobit = :1 OR ProductCode = :1 OR skid_number = :1 OR Location = :1 "
	$form_o.searchBoxQueryInactive:="Jobit = :1 OR ProductCode = :1 OR skid_number = :1 OR Location = :1 "
	//regarding the 'New' button:
	//specify which field is the table "id" holder to get incremented, if not in the trigger
	$form_o.idField:="pk_id"
	//see the New btn script if you want to customize any default values or use trigger
	
	//assign access membership that can make changes
	//this will disable the delete and save buttons, and the first/prev/next/last option to save if touched
	$form_o.editorGroup:="FG_Can_Adjust"
	
	app_form_Open($form_o)
	
End if 
