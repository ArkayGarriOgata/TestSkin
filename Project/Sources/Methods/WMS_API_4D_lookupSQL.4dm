//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_lookupSQL - Created v0.1.0-JJG (05/09/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($0; $ttSQL)

$ttSQL:="SELECT case_id,skid_number,case_status_code,bin_id FROM cases WHERE "

Case of 
	: (rft_state="BIN")
		$ttSQL:=$ttSQL+"bin_id = ?"
		
	: (rft_state="SKID")
		$ttSQL:=$ttSQL+"skid_number = ?"
		
	: (rft_state="CASE")
		$ttSQL:=$ttSQL+"case_id = ?"
		
End case 

$0:=$ttSQL