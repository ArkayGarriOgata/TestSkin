// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.btnResetASN   ( ) ->
// By: Mel Bohince @ 06/24/20, 16:10:27
// Description
// 
// ----------------------------------------------------

If (Form:C1466.selected.length>0)
	
	Form:C1466.listBoxEntities:=EDI_DESADV_UnSet_SentASN(Form:C1466.selected)
	Release_ShipMgmt_calcFooters
	
Else 
	uConfirm("Please select the releases that should have ASN revoked."; "Ok"; "Help")
End if 