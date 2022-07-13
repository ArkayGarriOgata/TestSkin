// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.InboundDelivery   ( ) ->
// By: Mel Bohince @ 06/24/20, 09:46:41
// Description
// apply a Mode/Load# to selected POs
// ----------------------------------------------------
// Removed by: Mel Bohince (6/25/20) remove settting edimsgid back to -1
// Added by: Mel Bohince (6/26/20) progress indicator
// Added by: Mel Bohince (7/15/20) read Inbound Delivery spreadsheet from clipboard
// Modified by: Mel Bohince (3/3/21) test for selection before doing manul method

uConfirm("Replace or append existing Mode?"; "Append"; "Replace")  // Added by: Mel Bohince (1/9/21) 
C_BOOLEAN:C305(IBD_Append_b)
If (ok=1)
	IBD_Append_b:=True:C214
Else 
	IBD_Append_b:=False:C215
End if 

uConfirm("Manual or Clipboard?"; "Manual"; "Clipboard")
If (ok=1)
	If (Form:C1466.selected.length>0)  // Modified by: Mel Bohince (3/3/21) 
		EDI_DESADV_BookingConf_manual
	Else 
		uConfirm("Please select the releases to Tag for ASN as if on an OPN."; "Ok"; "Help")
	End if 
	
Else   // Added by: Mel Bohince (7/15/20) read Inbound Delivery spreadsheet from clipboard
	EDI_DESADV_BookingConf_clipboar
	
End if 