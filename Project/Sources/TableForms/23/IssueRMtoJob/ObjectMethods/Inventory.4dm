// _______
// Method: [Raw_Materials_Transactions].IssueRMtoJob.Inventory   ( ) ->
// By: Mel Bohince @ 06/23/21, 09:26:01
// Description
// 
// ----------------------------------------------------



Case of 
	: (Form event code:C388=On Selection Change:K2:29)
		If (Form:C1466.clickedInventory#Null:C1517)
			RMX_IssueToJobReset("inventory-select")
			Form:C1466.location:=Form:C1466.clickedInventory.Location
			Form:C1466.purchaseOrder:=Form:C1466.clickedInventory.POItemKey
			Form:C1466.unitCost:=Form:C1466.clickedInventory.ActCost
			
			GOTO OBJECT:C206(*; "quantity")
		End if 
		
End case 


