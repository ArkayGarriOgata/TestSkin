// _______
// Method: [Raw_Materials_Transactions].IssueRMtoJob.BillOfMaterials   ( ) ->
// By: Mel Bohince @ 06/22/21, 11:40:51
// Description
// 
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Selection Change:K2:29) | (Form event code:C388=On Clicked:K2:4)
		If (Form:C1466.clickedMaterial#Null:C1517)
			RMX_IssueToJobReset("inventory-select")
			
			Form:C1466.sequence:=Form:C1466.clickedMaterial.Sequence
			Form:C1466.rawMatlCode:=Form:C1466.clickedMaterial.Raw_Matl_Code
			
			Form:C1466.inventory_es:=ds:C1482.Raw_Materials_Locations.query("Raw_Matl_Code = :1"; Form:C1466.clickedMaterial.Raw_Matl_Code).orderBy("POItemKey")
			
			
			
			GOTO OBJECT:C206(*; "Inventory")  //"BillOfMaterials"
		End if 
		
End case 