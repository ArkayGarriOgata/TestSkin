//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getEmptyBins - Created v0.1.0-JJG (05/09/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($ttSQL; $ttLine)
ARRAY TEXT:C222($sttEmptyBinIds; 0)

If (WMS_API_4D_DoLogin)
	$ttSQL:="SELECT bin_id FROM bins WHERE location_type_code='FG' "
	$ttSQL:=$ttSQL+" AND bin_id LIKE 'BNV-%-%-%'"
	$ttSQL:=$ttSQL+" AND bin_id not in "
	$ttSQL:=$ttSQL+"(SELECT DISTINCT bin_id FROM cases) "
	$ttSQL:=$ttSQL+" ORDER BY bin_ID ASC"
	
	SQL EXECUTE:C820($ttSQL; $sttEmptyBinIds)
	If (OK=1)
		If (Not:C34(SQL End selection:C821))
			SQL LOAD RECORD:C822(SQL all records:K49:10)
		End if 
		SQL CANCEL LOAD:C824
		WMS_API_4D_DoLogout
		
		WMS_API_4D_getEmptyBins_Write(->$sttEmptyBinIds)
		BEEP:C151
	End if 
	
Else 
	ALERT:C41("Could not connect to WMS database.")
	
End if 