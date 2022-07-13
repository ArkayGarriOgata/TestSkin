
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 02/20/15, 16:41:21
// ----------------------------------------------------
// Method: [WMS_SerializedShippingLabels].MoveCase_dio
// Description
// 
//
// Parameters
// ----------------------------------------------------


Case of 
	: (Form event code:C388=On Load:K2:1)
		wmss_initMove
		
	: (Form event code:C388=On Data Change:K2:15)
		
		Case of 
			: (rft_response="DONE")  //A way to bail
				CANCEL:C270
				
			: (rft_state="object")
				$success:=wmss_ScanObject
				
			: (rft_state="destination")
				$success:=wmss_ScanDestination
				
			Else 
				rft_error_log:="Reset"
				SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215)
				wmss_initMove
		End case 
		
		rft_Response:=""
		
End case 
