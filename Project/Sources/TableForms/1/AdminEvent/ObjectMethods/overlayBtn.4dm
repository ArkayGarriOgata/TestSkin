
If (Current user:C182="Designer")
	C_TEXT:C284($choice)
	
	$choice:=uYesNoCancel("Overlay aMs bins with WMS"; "Racks"; "All"; "Cancel")
	
	Case of 
		: ($choice="Racks")  // Modified by: Mel Bohince (3/22/16) new option
			wms_api_get_recon_racks_only
			
		: ($choice="All")
			wms_api_get_reconciliation
			
	End case 
	
Else 
	BEEP:C151
	ALERT:C41("Not Designer ehh?")
End if 
