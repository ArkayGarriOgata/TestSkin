//%attributes = {}
// _______
// Method: Release_UI   ( release_entitySelection ) ->
// By: Mel Bohince @ 06/06/20, 08:33:33
// Description
// display a listbox of releases that are to be shipped and work with the ELC/TMC shipping workflow
// releases limited to ELC customer group
// ----------------------------------------------------
//* see also:  // based on Vendor_UI
//app_form_Button , app_form_Detail , app_form_ListBox , app_form_Mgmt , app_form_Notice_Text , app_form_Open , app_form_Refresh , app_form_Save_touched
//*/
// Modified by: Mel Bohince (7/16/20) use $form_o.elcOpenFirm as basis for all later queries
// Modified by: Mel Bohince (7/18/20) add logger and stop search widget firing on first on load
C_LONGINT:C283($1; $pid)

If (Count parameters:C259=0)
	$pid:=New process:C317(Current method name:C684; 0; Current method name:C684; 1; *)
	SHOW PROCESS:C325($pid)
	
Else 
	C_TEXT:C284(elcShippingLogFile)
	utl_LogIt("init")
	utl_LogIt(Timestamp:C1445+"\tELC Shipping dialog opened"; 0)
	//see utl_logit in:
	//[Customers_ReleaseSchedules].ShipMgmt   ( ) 
	//[Customers_ReleaseSchedules].ShipMgmt.ListBox1   ( ) 
	//Release_ShipMgmt_calculated
	//[Customers_ReleaseSchedules].PickUpList.SearchPicker   ( ) 
	//[Customers_ReleaseSchedules].ShipMgmt.showLog   ( ) 
	//EDI_DESADV_FindBy
	
	C_BOOLEAN:C305(searchWidgetInited; showLaunchDetails)  // Modified by: Mel Bohince (7/18/20) keep it from running when dialog first opens
	searchWidgetInited:=False:C215
	showLaunchDetails:=False:C215
	
	C_LONGINT:C283(footerCount; footerQty; footerCases; vAskMePID)
	vAskMePID:=0
	ADDR_getInfoWithCache
	PK_getSpecByCPN
	SET MENU BAR:C67(<>DefaultMenu)  // Added by: Mel Bohince (6/25/20) 
	
	C_OBJECT:C1216($form_o)
	$form_o:=New object:C1471
	//now customize parameters
	$form_o.masterClass:=ds:C1482.Customers_ReleaseSchedules
	$form_o.masterTable:=Table:C252(->[Customers_ReleaseSchedules:46])  // Modified by: Mel Bohince (4/18/20) can't use a pointer in the attribute
	$form_o.baseForm:="ShipMgmt"  //the two page listbox + detail form
	$form_o.detailForm:="ShipDetail"  //the one page detail form when doing the "Open Multiple"
	
	$form_o.editEntity:=New object:C1471  //this will be the entity shown on the detail form
	$form_o.parentForm:=0  //used to callback to the listbox when in multiwindow mode has changes
	$form_o.deleteAction:="delete"  // or "delete" if you want the record deleted on user's perogative
	C_COLLECTION:C1488($noticeFields_c)
	$noticeFields_c:=New collection:C1472("ProductCode"; "CustomerRefer")  // field(s) to be used by delete to confirm the record
	$form_o.noticeText_c:=$noticeFields_c
	//any time that the listbox selection is to be init'd
	$form_o.defaultQuery:=New object:C1471("criteria"; "Name = :1 "; "value"; "Name")
	$form_o.defaultOrderBy:="Shipto asc, Sched_Date asc"
	//these are for the search box and the active button, active meaning not yet shipped
	//$form_o.searchBoxQueryActive:="(CustomerRefer = :1 or ProductCode = :1 or Shipto = :1 or Mode = :1) and CUSTOMER.ParentCorp = :2 and CustomerRefer # :3 and OpenQty > :4"
	//$form_o.searchBoxQueryInactive:="(CustomerRefer = :1 or ProductCode = :1 or Shipto = :1 or Mode = :1) and CUSTOMER.ParentCorp = :2 and CustomerRefer # :3"
	//$form_o.listBoxEntities:=$form_o.masterClass.query("CUSTOMER.ParentCorp = :1 and CustomerRefer # :2 and OpenQty > :3";"Estée Lauder Companies";"<@";0).orderBy($form_o.defaultOrderBy)
	$form_o.searchBoxQueryActive:="CustomerRefer = :1 or ProductCode = :1 or Shipto = :1 or Mode = :1"
	$form_o.searchBoxQueryInactive:="CustomerRefer = :1 or ProductCode = :1 or Shipto = :1 or Mode = :1"
	
	utl_LogIt(Timestamp:C1445+"\t Initial Query"; 0)
	$form_o.elcOpenFirm:=$form_o.masterClass.query("CUSTOMER.ParentCorp = :1 and CustomerRefer # :2 and OpenQty > :3"; "Estée Lauder Companies"; "<@"; 0)
	utl_LogIt(Timestamp:C1445+"\t Initial Query fini"; 0)
	$form_o.listBoxEntities:=$form_o.elcOpenFirm.orderBy($form_o.defaultOrderBy)
	utl_LogIt(Timestamp:C1445+"\t Initial Query copied"; 0)
	
	Release_ShipMgmt_calcFooters
	
	utl_LogIt(Timestamp:C1445+"\t Getting distinct shipto's"; 0)
	If (True:C214)
		If (Storage:C1525.ELC_ShipTos_c=Null:C1517)  //first time since ams launch
			C_COLLECTION:C1488($shipTos_c; $verboseShipTos_c)
			//for the Search popup, create a collection of (addressid+country,city,addr_name) to choose from
			$shipTos_c:=$form_o.listBoxEntities.distinct("Shipto")
			$verboseShipTos_c:=New shared collection:C1527
			C_TEXT:C284($address)
			For each ($address; $shipTos_c)
				$verboseShipTos_c.push($address+" - "+ADDR_getInfoWithCache($address))
			End for each 
			
			Use (Storage:C1525)  //save it for reuse
				Storage:C1525.ELC_ShipTos_c:=$verboseShipTos_c
			End use 
		End if 
		$form_o.verboseShipTos_c:=Storage:C1525.ELC_ShipTos_c
		
	Else   //old way
		$verboseShipTos_c:=New collection:C1472
		$shipTos_c:=$form_o.listBoxEntities.distinct("Shipto")
		C_TEXT:C284($address)
		For each ($address; $shipTos_c)
			$verboseShipTos_c.push($address+" - "+ADDR_getInfoWithCache($address))
		End for each 
		$form_o.verboseShipTos_c:=$verboseShipTos_c
	End if   //true
	utl_LogIt(Timestamp:C1445+"\t Getting distinct shipto's fini"; 0)
	
	$form_o.findBy:=""
	
	//regarding the 'New' button:
	//specify which field is the table "id" holder to get incremented, if not in the trigger
	$form_o.idField:="ReleaseNumber"
	//see the New btn script if you want to customize any default values or use trigger
	
	//assign access membership that can make changes
	//this will disable the delete and save buttons, and the first/prev/next/last option to save if touched
	$form_o.editorGroup:="ASN_sender"
	
	app_form_Open($form_o)
	
End if 



