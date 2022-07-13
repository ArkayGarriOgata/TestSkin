//%attributes = {}
// _______
// Method: MRO_ControlCenter_UI   ( ) ->
// By: Mel Bohince @ 05/31/19, 13:54:26
// Description
// open the main window for the module
// ----------------------------------------------------
If (False:C215)  //see also:
	app_form_button
	app_form_Detail
	app_form_ListBox
	app_form_Mgmt
	app_form_Notice_Text
	app_form_Open
	app_form_Refresh
	app_form_Save_touched
End if 


C_LONGINT:C283($1; $pid)

If (Count parameters:C259=0)
	$pid:=New process:C317(Current method name:C684; 0; Current method name:C684; 1; *)
	SHOW PROCESS:C325($pid)
	
Else   //init
	C_OBJECT:C1216($form_o)
	
	$form_o:=New object:C1471
	
	//now customize parameters
	$form_o.masterClass:=ds:C1482.MaintRepairSupply_Bins
	$form_o.masterTable:=Table:C252(->[MaintRepairSupply_Bins:161])  // Modified by: Mel Bohince (4/18/20) can't use a pointer in the attribute
	$form_o.subClass:=ds:C1482.Raw_Materials
	$form_o.subTable:=Table:C252(->[Raw_Materials:21])  // Modified by: Mel Bohince (4/18/20) can't use a pointer in the attribute
	$form_o.baseForm:="MRO_Mgmt"  //the two page listbox + detail form
	$form_o.detailForm:="MRO_Detail"  //the one page detail form when doing the "Open Multiple"
	//$form_o.listBoxEntities:=New object  //this will be selection that the listbox uses
	$form_o.bins:=New object:C1471
	$form_o.parts:=New object:C1471
	
	$form_o.editEntity:=New object:C1471  //this will be the entity shown on the detail form
	$form_o.editEntity:=New object:C1471  //this will be the entity shown on the detail form
	
	$form_o.parentForm:=0  //used to callback to the listbox when in multiwindow mode has changes
	
	$form_o.deleteAction:="Delete"  // or "delete" if you want the record deleted on user's perogative
	C_COLLECTION:C1488($noticeFields_c)
	$noticeFields_c:=New collection:C1472("Bin"; "PartNumber")  // field(s) to be used by delete to confirm the record
	$form_o.noticeText_c:=$noticeFields_c
	//any time that the listbox selection is to be init'd
	$form_o.defaultQuery:=New object:C1471("criteria"; "Bin = :1 "; "value"; "Bin")
	$form_o.defaultBinsOrderBy:="Bin asc"
	$form_o.defaultPartsOrderBy:="Raw_Matl_Code asc"
	//these are for the search box and the active button
	$form_o.searchBoxQueryBins:="Bin = :1 OR PartNumber = :1"
	$form_o.searchBoxQueryParts:="( Raw_Matl_Code = :1 OR VendorPartNum = :1 OR Description = :1  OR DepartmentID = :1  OR UsedBy = :1  OR PartType = :1 ) AND CommodityCode > :2"
	//regarding the 'New' button:
	//specify which field is the table "id" holder to get incremented, if not in the trigger
	$form_o.idField:="Bin"
	//see the New btn script if you want to customize any default values or use trigger
	
	//assign access membership that can make changes
	//this will disable the delete and save buttons, and the first/prev/next/last option to save if touched
	$form_o.editorGroup:="MaintRepairSupplies"
	
	$form_o.rm:=New object:C1471
	
	app_form_Open($form_o)
	
	
End if 

