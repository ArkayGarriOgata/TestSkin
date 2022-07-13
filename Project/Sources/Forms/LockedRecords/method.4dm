// _______
// FormMethod: LockedRecords   ( ) ->
// By: Mel Bohince @ 01/16/20, 13:51:16
// Description
// 
// ----------------------------------------------------


Case of 
	: (Form event code:C388=On Load:K2:1)
		C_COLLECTION:C1488(lockedRecordCollection)
		
		ams_get_tables
		
		lockedRecordCollection:=New collection:C1472
End case 
