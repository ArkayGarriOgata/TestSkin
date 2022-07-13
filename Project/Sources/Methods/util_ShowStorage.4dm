//%attributes = {}
// _______
// Method: util_ShowStorage   ( ) ->
// By: Mel Bohince @ 06/10/21, 07:50:53
// Description
// display what's in Storage
// call from Edit menu
// ----------------------------------------------------

C_OBJECT:C1216($currentStorageCatalog_o)
$currentStorageCatalog_o:=New shared object:C1526

$currentStorageCatalog_o:=Storage:C1525

C_TEXT:C284($currentStorageCatalog_t)
$currentStorageCatalog_t:=JSON Stringify:C1217($currentStorageCatalog_o; *)

utl_LogIt("init")
utl_LogIt($currentStorageCatalog_t)
utl_LogIt("show"; 0; "Storage")
