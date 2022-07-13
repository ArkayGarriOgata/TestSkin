// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.LoadOPN   ( ) ->
// By: Mel Bohince
// Modified by: Mel Bohince (8/13/20) add option to tag selected instead of TMC's OPN rpt
// Modified by: Mel Bohince (2/25/21) change the default button
// Modified by: Mel Bohince (2/25/21) enable btn w/o having selection, but test if manual mode

uConfirm("OPN from TMC?"; "TMC"; "Arkay")
If (ok=0)  //hand selected
	
	If (Form:C1466.selected.length>0)  // Modified by: Mel Bohince (2/25/21) 
		
		Form:C1466.listBoxEntities:=EDI_DESADV_ArkayOPN  // Modified by: Mel Bohince (8/13/20) add option to tag selected instead of TMC's OPN rpt
		Form:C1466.message:="PO's called off by Arkay"
		
	Else 
		uConfirm("Please select the releases to Tag for ASN as if on an OPN."; "Ok"; "Help")
	End if 
	
Else   //from OPN spreadsheet
	Form:C1466.listBoxEntities:=EDI_DESADV_PO_Notification  //TMC, the original way
	Form:C1466.message:="PO's called off by TMC"
End if 
asQueryTypes{0}:="Quick search..."

OBJECT SET ENABLED:C1123(*; "select@"; False:C215)
Release_ShipMgmt_calcFooters