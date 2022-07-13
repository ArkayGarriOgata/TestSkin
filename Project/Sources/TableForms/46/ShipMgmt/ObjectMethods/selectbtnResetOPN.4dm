// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.btnResetOPN   ( ) ->
// By: Mel Bohince @ 06/23/20, 14:17:17
// Description
// 
// ----------------------------------------------------
If (Form:C1466.selected.length>0)
	Form:C1466.listBoxEntities:=EDI_DESADV_UnSet_Notification(Form:C1466.selected)
	Release_ShipMgmt_calcFooters
	
Else 
	uConfirm("Please select the releases that should have OPN reset."; "Ok"; "Help")
End if 