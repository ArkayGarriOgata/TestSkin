//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/08/07, 11:41:53
// ----------------------------------------------------
// Method: util_SetSyncParameters()  --> 
// Description
// 
//
// ----------------------------------------------------

// ----------------------------------------------------
READ ONLY:C145([z_administrators:2])
ALL RECORDS:C47([z_administrators:2])
<>SERVER_DESIGNATION:=[z_administrators:2]ServerDesignation:31
<>Sync_Activated:=False:C215  //[z_administrators]SyncronizeServers
REDUCE SELECTION:C351([z_administrators:2]; 0)

If (<>Sync_Activated)
	utl_Logfile("server.log"; "  Sync flag is Activated")
	utl_Logfile("server.log"; "  Server designation as '"+<>SERVER_DESIGNATION+"'")
Else 
	utl_Logfile("server.log"; "  Sync flag is OFF")
End if 
