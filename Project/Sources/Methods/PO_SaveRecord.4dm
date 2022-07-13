//%attributes = {}
// Method: PO_SaveRecord () -> 
// ----------------------------------------------------
// by: mel: 10/28/04, 09:48:09
// ----------------------------------------------------
// Description:
// Save a po record and run validate form event thingy cause otherwise it may not run

C_BOOLEAN:C305(allow_supply_chain)

uUpdateTrail(->[Purchase_Orders:11]ModDate:31; ->[Purchase_Orders:11]ModWho:32; ->[Purchase_Orders:11]zCount:30)

allow_supply_chain:=False:C215  // only activate for commodity 17

PO_setExtendedTotals("all")

If ([Purchase_Orders:11]CompanyID:43="5")  //attempting supply chain
	If (Not:C34(allow_supply_chain))
		uConfirm("SupplyChain PO's only allowed with commodity 1 & 17, reverting to Roanoke shipto."; "OK"; "Help")
		$location:="Default"
		[Purchase_Orders:11]CompanyID:43:="2"
		[Purchase_Orders:11]SupplyChainPO:55:=""
		rbShipTo2:=1
		rbShipTo4:=0
	End if 
End if 

PO_EmailConfirmation

If (Count parameters:C259=1)
	SAVE RECORD:C53([Purchase_Orders:11])
End if 