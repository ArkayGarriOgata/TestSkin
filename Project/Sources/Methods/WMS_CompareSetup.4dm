//%attributes = {"executedOnServer":true}
// -------
// Method: WMS_CompareSetup   ( ) ->
// By: Mel Bohince @ 12/11/18, 11:28:00
// Description
// !!!!! set to execute on server
// ----------------------------------------------------
C_DATE:C307($dateOfCompare)
READ WRITE:C146([Finished_Goods_Locations:35])
ALL RECORDS:C47([Finished_Goods_Locations:35])
$dateOfCompare:=Current date:C33
zwStatusMsg("WMS_CompareSetup"; "Clearing LastCycleCount.")
APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; FGL_initLastCycleCount($dateOfCompare))

UNLOAD RECORD:C212([Finished_Goods_Locations:35])
