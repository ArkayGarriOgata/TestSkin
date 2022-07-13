//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_SendSuperCaseSQL - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($0; $ttSQL)
C_BOOLEAN:C305($1; $fDoSkidNum)
$fDoSkidNum:=$1

$ttSQL:="INSERT INTO cases (case_id,glue_date,qty_in_case,jobit,case_status_code,ams_location,"
$ttSQL:=$ttSQL+"bin_id,insert_datetime,update_datetime,update_initials,warehouse"
If ($fDoSkidNum)
	$ttSQL:=$ttSQL+",skid_number"
End if 
$ttSQL:=$ttSQL+") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?"
If ($fDoSkidNum)
	$ttSQL:=$ttSQL+", ?"
End if 
$ttSQL:=$ttSQL+")"

$0:=$ttSQL