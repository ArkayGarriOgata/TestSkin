//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_compareToAMS_Update - Created v0.1.0-JJG (05/18/16)
// Modified by: Mel Bohince (12/11/18) utilize WMS.[cases]InhibitTrigger so update_timestamp doesn't change
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 
C_DATE:C307($1; $dInventory)
C_TEXT:C284($2; $3; $4; $ttWareHouse; $ttBinID; $ttJobit; $ttCheck; $ttUpdate; $ttWhere)
C_LONGINT:C283($xlCount)
C_BOOLEAN:C305($inhibitTrigger)  // Modified by: Mel Bohince (12/11/18) 
$inhibitTrigger:=True:C214
$dInventory:=$1
$ttWareHouse:=$2
$ttBinID:=$3
$ttJobit:=$4
$ttWhere:=" WHERE bin_id = ? AND jobit = ? AND (case_status_code < 300 OR case_status_code = 350)"
$ttCheck:="SELECT COUNT(*) FROM cases "+$ttWhere
$ttUpdate:="UPDATE cases SET inventory_date = ?, warehouse = ?, update_initials='ams', InhibitTrigger = ? "+$ttWhere

SQL SET PARAMETER:C823($ttBinID; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttJobit; SQL param in:K49:1)
SQL EXECUTE:C820($ttCheck; $xlCount)
Case of 
	: (OK=0)
		
	: (SQL End selection:C821)
		SQL CANCEL LOAD:C824
		
	Else 
		SQL LOAD RECORD:C822(SQL all records:K49:10)
		SQL CANCEL LOAD:C824
		If ($xlCount>0)
			SQL SET PARAMETER:C823($dInventory; SQL param in:K49:1)
			SQL SET PARAMETER:C823($ttWareHouse; SQL param in:K49:1)
			SQL SET PARAMETER:C823($inhibitTrigger; SQL param in:K49:1)
			SQL SET PARAMETER:C823($ttBinID; SQL param in:K49:1)
			SQL SET PARAMETER:C823($ttJobit; SQL param in:K49:1)
			SQL EXECUTE:C820($ttUpdate)
			If (OK=1)
				SQL CANCEL LOAD:C824
			End if 
		End if 
		
End case 





