// _______
// Method: "Preflight" -- [Customers_ReleaseSchedules].ShipMgmt.selectPreASN   ( ) ->
// By: Mel Bohince
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (4/28/21)

consolidationType:="Parcel"  // Modified by: Mel Bohince (2/15/21) 
C_DATE:C307(epd)  // Modified by: Mel Bohince (2/23/21) so this can be reference in the report
epd:=!00-00-00!

If (Not:C34(Shift down:C543))  // Modified by: Mel Bohince (4/28/21) 
	Form:C1466.listBoxEntities:=EDI_DESADV_get_PO_Calloffs("Log Only"; Form:C1466.selected)
	
	
	Form:C1466.message:="PO's ready for ASN"
	asQueryTypes{0}:="Quick search..."
	OBJECT SET ENABLED:C1123(*; "select@"; False:C215)
	Release_ShipMgmt_calcFooters
	
Else 
	REL_PalletCalculation(Form:C1466.selected)  // Modified by: Mel Bohince (4/28/21) 
End if 
