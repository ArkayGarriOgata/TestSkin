// _______
// Method: On Backup Shutdown   ( ) ->
// By: Mel Bohince @ 07/13/21, 12:39:59
// Description
// used to trigger making of copies of the ams backups
// ----------------------------------------------------
// Modified by: Garri Ogata (9/7/21) added ArkyktAmsHelpEmail
Compiler_0000_ConstantsToDo
C_LONGINT:C283($1)  //idk, says to in the docs

If ($1#0)
	utl_Logfile("ams_backup.log"; "BACKUP FAILED per On Backup Shutdown.")
	EMAIL_Sender("[Bkup2Dbx] "+"BACKUP FAILED"; ""; "BACKUP FAILED per On Backup Shutdown."; ArkyktAmsHelpEmail)
End if 

$pid:=New process:C317("util_BackupToDropBox"; 0; "util_BackupToDropBox")
If (False:C215)
	util_BackupToDropBox
End if 
