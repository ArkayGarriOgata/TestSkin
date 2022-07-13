//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wmss_ScanObjectMulti_4D - Created v0.1.0-JJG (05/06/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fSuccess; $fContinue)
C_TEXT:C284($ttSQL)
$fSuccess:=False:C215

$ttSQL:=wmss_ScanObjectMulti_4D_where

Case of 
	: (Length:C16($ttSQL)=0)
		//error response handled in wmss_ScanObjectMulti_4D_where
		
	: (Not:C34(WMS_API_4D_DoLogin))
		rft_error_log:="Could not connect to WMS."
		
	Else 
		$ttSQL:="SELECT case_id,skid_number,case_status_code,bin_id,jobit FROM CASES "+$ttSQL
		If (rft_object="skid")
			$fSuccess:=wmss_ScanObjectMulti_4D_Skid($ttSQL)
		Else 
			$fSuccess:=wmss_ScanObjectMulti_4D_Case($ttSQL)
		End if 
		
		If ($fSuccess)
			rft_error_log:=""
			SetObjectProperties(""; ->rft_error_log; False:C215)
		End if 
		
		WMS_API_4D_DoLogout
End case 

$0:=$fSuccess