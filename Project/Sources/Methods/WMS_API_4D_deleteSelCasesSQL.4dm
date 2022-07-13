//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_deleteSelCasesSQL - Created v0.1.0-JJG (05/12/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($0; $ttSQL)

If (rft_response="BNV-99-99-9")
	$ttSQL:="DELETE FROM cases WHERE case_id = ?"
Else 
	$ttSQL:="UPDATE cases SET bin_id='BNV-99-99-9', skid_number='', case_status_code=400, from_bin_id = ?, update_initials = ? "
	$ttSQL:=$ttSQL+"WHERE case_id = ?"  //left update_datetime off, WMS trigger handles it
End if 

$0:=$ttSQL