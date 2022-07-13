//%attributes = {}
// _______
// Method: RMX_IssueToJobReset   ( clearWhat ) ->
// By: Mel Bohince @ 06/23/21, 06:27:48
// Description
// clear objects on the IssueRMtoJob form
// ----------------------------------------------------

C_TEXT:C284($clearWhat; $1)
$clearWhat:=$1

Case of 
	: ($clearWhat="job-form-entry")
		Form:C1466.findJobFormID:=""  //to be used in the search box
		Form:C1466.jobFormDescription:="Enter the Job form's id"
		Form:C1466.jobFormID:=""
		Form:C1466.billOfMaterial_es:=ds:C1482.Job_Forms_Materials.newSelection()
		Form:C1466.billOfMaterialHold_es:=Form:C1466.billOfMaterial_es
		Form:C1466.inventory_es:=ds:C1482.Raw_Materials_Locations.newSelection()
		
	: ($clearWhat="budget-item-select")
		Form:C1466.sequence:=0
		Form:C1466.rawMatlCode:=""
		Form:C1466.billOfMaterial_es:=Form:C1466.billOfMaterialHold_es
		Form:C1466.inventory_es:=ds:C1482.Raw_Materials_Locations.newSelection()
		
	: ($clearWhat="inventory-select")
		Form:C1466.location:=""
		Form:C1466.purchaseOrder:=""
		Form:C1466.unitCost:=0
		Form:C1466.quantity:=0
		Form:C1466.reference:=""
		
	Else   //init
		
		
		
		
End case 
