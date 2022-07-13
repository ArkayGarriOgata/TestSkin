//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_compareToAMS_Match - Created v0.1.0-JJG (05/18/16)
// Modified by: Mel Bohince (12/11/18) utilize WMS.[cases]InhibitTrigger so update_timestamp doesn't change
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_DATE:C307($1; $dInventory)
C_TEXT:C284($2; $3; $4; $5; $ttWareHouse; $ttInventoryBinID; $ttBinID; $ttJobit; $ttUpdate)
C_BOOLEAN:C305($inhibitTrigger)  // Modified by: Mel Bohince (12/11/18) 
$inhibitTrigger:=True:C214
$dInventory:=$1
$ttWareHouse:=$2
$ttInventoryBinID:=$3
$ttBinID:=$4
$ttJobit:=$5
$ttUpdate:="UPDATE cases SET inventory_date=?, warehouse = ?, inventory_bin_id = ?, InhibitTrigger = ? "
$ttUpdate:=$ttUpdate+" WHERE bin_id = ? AND jobit = ? AND (case_status_code < 300 OR case_status_code = 350)"

SQL SET PARAMETER:C823($dInventory; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttWareHouse; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttInventoryBinID; SQL param in:K49:1)
SQL SET PARAMETER:C823($inhibitTrigger; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttBinID; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttJobit; SQL param in:K49:1)
SQL EXECUTE:C820($ttUpdate)
If (OK=1)
	SQL CANCEL LOAD:C824
End if 

