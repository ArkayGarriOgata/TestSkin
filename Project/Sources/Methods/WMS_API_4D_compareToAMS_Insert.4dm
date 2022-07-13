//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_compareToAMS_Insert - Created v0.1.0-JJG (05/18/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($1; $2; $3; $4; $6; $ttPkgID; $ttPkgType; $ttInits; $ttWarehouse; $ttInventoryBin; $ttInsert)
C_DATE:C307($5; $dInventory)
$ttPkgID:=$1
$ttPkgType:=$2
$ttInits:=$3
$ttWarehouse:=$4
$dInventory:=$5
$ttInventoryBin:=$6

$ttInsert:="INSERT INTO missing_inventory (package_id,package_type,update_initials,warehouse,inventory_date,inventory_bin_id) VALUES (?,?,?,?,?,?)"
SQL SET PARAMETER:C823($ttPkgID; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttPkgType; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttInits; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttWarehouse; SQL param in:K49:1)
SQL SET PARAMETER:C823($dInventory; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttInventoryBin; SQL param in:K49:1)
SQL EXECUTE:C820($ttInsert)
If (OK=1)
	SQL CANCEL LOAD:C824
End if 