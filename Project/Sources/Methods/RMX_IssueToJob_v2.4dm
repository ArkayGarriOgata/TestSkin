//%attributes = {}
// _______
// Method: RMX_IssueToJob_v2   ( ) ->
// By: Mel Bohince @ 06/22/21, 09:47:01
// Description
// provide point and click guidence for a material issue 
//   to a job by building a [Raw_Materials_Transactions]
//   then allowing the trigger to relieve inventory 
//   and allocations
// ----------------------------------------------------

C_LONGINT:C283($1; $pid)

If (Count parameters:C259=0)  //singleton
	zwStatusMsg("RMX"; "Issuing to jobs")
	$pid:=New process:C317(Current method name:C684; 0; Current method name:C684; 1; *)
	SHOW PROCESS:C325($pid)
	
Else 
	//[Job_Forms_Materials]
	//[Raw_Materials_Locations]
	//[Raw_Materials_Transactions]
	C_OBJECT:C1216($form_o)
	$form_o:=New object:C1471
	
	//front matters for the dialog
	$form_o.masterClass:=ds:C1482.Raw_Materials_Transactions
	$form_o.masterTable:=Table:C252(->[Raw_Materials_Transactions:23])  // Modified by: Mel Bohince (4/18/20) can't use a pointer in the attribute
	$form_o.baseForm:="IssueRMtoJob"  //the two page listbox + detail form
	$form_o.windowTitle:="Issue Raw Material to Job"
	
	//use RMX_IssueToJobReset to restore
	//to find the target jobform
	$form_o.findJobFormID:=""  //to be used in the search box
	$form_o.jobFormDescription:="Enter the Job form's id"
	
	//to build a RM transaction entity
	$form_o.transactionDate:=4D_Current_date
	$form_o.transactionType:="Issue"
	$form_o.jobFormID:=""
	$form_o.sequence:=0
	$form_o.rawMatlCode:=""
	$form_o.location:=""
	$form_o.purchaseOrder:=""
	$form_o.unitCost:=0
	$form_o.quantity:=0
	$form_o.reference:=""
	
	//the listboxes:
	$form_o.billOfMaterial_es:=ds:C1482.Job_Forms_Materials.newSelection()  //will list the budgeted materials for the $form_o.findJobFormID
	$form_o.billOfMaterialHold_es:=$form_o.billOfMaterial_es  //to restore pre-clicked state
	
	$form_o.inventory_es:=ds:C1482.Raw_Materials_Locations.newSelection()  //will list the inventry of the selected budget material
	
	$form_o.transactions_es:=ds:C1482.Raw_Materials_Transactions.newSelection()  //will list the pending issue transactions from this session
	
	app_form_Open($form_o)
	
End if 
