//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getReceipts_AggSQL - Created v0.1.0-JJG (05/16/16)
// Modified by: JJG (03/18/17)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//C_TEXT($0;$ttSQL)

//$ttSQL:="SELECT  transaction_id, jobit, bin_id, transaction_initials, "
//$ttSQL:=$ttSQL+" actual_qty, skid_number, number_of_cases, from_bin_id "
//$ttSQL:=$ttSQL+" FROM ams_exports "
//$ttSQL:=$ttSQL+" WHERE ((transaction_state_indicator = 'T') "  //not yet imported but Targeted this run'
//$ttSQL:=$ttSQL+" AND (transaction_type_code = 100)) "  //looking for specific types of transactions *** was <= $1  ****
//  //$ttSQL:=$ttSQL+" GROUP BY skid_number, from_bin_id"

//$0:=$ttSQL


C_TEXT:C284($0; $ttSQL)

$ttSQL:="SELECT  transaction_id, jobit, bin_id, transaction_initials, "
$ttSQL:=$ttSQL+" actual_qty, skid_number, number_of_cases, from_bin_id, transaction_date, transaction_time "  //v1.0.3-JJG (03/13/17) - added ,transaction_date,transaction_time
$ttSQL:=$ttSQL+" FROM ams_exports "
$ttSQL:=$ttSQL+" WHERE ((transaction_state_indicator = 'T') "  //not yet imported but Targeted this run'
$ttSQL:=$ttSQL+" AND (transaction_type_code = 100)) "  //looking for specific types of transactions *** was <= $1  ****
//$ttSQL:=$ttSQL+" GROUP BY skid_number, from_bin_id"

$0:=$ttSQL

