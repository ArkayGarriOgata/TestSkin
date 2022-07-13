
If (Current user:C182="Designer")
	wms_api_get_recon_single_area
	
Else 
	BEEP:C151
	ALERT:C41("Not Designer ehh?")
End if 
