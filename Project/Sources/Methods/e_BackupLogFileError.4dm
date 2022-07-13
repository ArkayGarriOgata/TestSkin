//%attributes = {}
// _______
// Method: eBackupLogFileError   ( ) ->
// By: Mel Bohince @ 07/16/21, 15:56:22
// Description
// don't let server display an error box
// ----------------------------------------------------

utl_Logfile("ams_backup.log"; "Error encountered, Method: "+Error method+" Line#: "+String:C10(Error line)+" Error#: "+String:C10(Error))
