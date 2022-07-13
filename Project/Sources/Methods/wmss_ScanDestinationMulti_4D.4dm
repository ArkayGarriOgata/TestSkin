//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wmss_ScanDestinationMulti_4D - Created v0.1.0-JJG (05/06/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

If (WMS_API_4D_DoLogin)
	
	Case of 
		: ((Substring:C12(rft_Response; 1; 2)="BN"))
			wmss_ScanDestinationMulti_4DBin
			
			
		: (Length:C16(rft_Response)=20)
			wmss_ScanDestinationMulti_4DSkd
			
			
		Else 
			rft_error_log:="Bin or Skid required"
			
	End case 
	
	WMS_API_4D_DoLogout
Else 
	rft_error_log:="Could not connect to WMS."
End if 

