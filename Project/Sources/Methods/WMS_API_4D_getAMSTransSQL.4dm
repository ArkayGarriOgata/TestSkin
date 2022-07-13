//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getAMSTransSQL - Created v0.1.0-JJG (05/16/16)
// Modified by: Mel Bohince (11/30/18) add from_skid_id

If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($0; $ttSQL)
C_TEXT:C284($1; $txType)
$txType:=$1


$ttSQL:="SELECT transaction_id,transaction_type_code,transaction_state_indicator,transaction_date,transaction_time,transaction_initials,b_o_l_number,release_number,"
$ttSQL:=$ttSQL+"jobit,bin_id,actual_qty,to_ams_location,from_ams_location,skid_number,case_id,number_of_cases,from_bin_id,from_skid_id FROM ams_exports WHERE "
$ttSQL:=$ttSQL+" transaction_state_indicator = 'S' "
If (Length:C16($txType)>0)
	$ttSQL:=$ttSQL+" AND transaction_type_code = "+$txType
End if 

$0:=$ttSQL