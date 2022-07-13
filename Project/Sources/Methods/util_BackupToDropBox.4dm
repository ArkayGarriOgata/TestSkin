//%attributes = {}
// _______
// Method: util_BackupToDropBox   ( ) ->
// By: Mel Bohince @ 07/13/21, 12:18:09
// Description
// like util_BackupToDropBox_EOS but triggered by
// database method On Backup Shutdown

// assuming that multiple 4BK's (keep last 7) will be in configured
// backup folder, these will be mirrored to a local external 
// drive and to dropbox.
// ----------------------------------------------------
// Modified by: Garri Ogata (9/7/21) added ArkyktAmsHelpEmail
Compiler_0000_ConstantsToDo
ON ERR CALL:C155("e_BackupLogFileError")  // Modified by: Mel Bohince (7/16/21) 

If (False:C215)  //test with
	//SETUP (once on server):
	util_JSON_CreateConfig2  //set up config file the first time, run on the server in 4D Mono, will be set in the server's Resource folder
	// then call this from On Server Startup
	util_BackupLogFile
End if 

C_OBJECT:C1216($pathConfigs_o; $originalsFolder_o; $mirrorsFolder_o; $dropboxFolder_o)

$pathConfigs_o:=util_JSON_ObjFromResourceFolder("config_Backup")

If ($pathConfigs_o#Null:C1517)
	
	//contents of this named folder will be moved to Dropbox and the Mirror folders
	$originalsFolder_o:=Folder:C1567(Convert path system to POSIX:C1106($pathConfigs_o.backupOriginals))
	//this is the local copy for historical reference
	$mirrorsFolder_o:=Folder:C1567(Convert path system to POSIX:C1106($pathConfigs_o.backupMirrors))
	//this is the Dropbox folder on the local mac for emergency restores
	$dropboxFolder_o:=Folder:C1567(Convert path system to POSIX:C1106($pathConfigs_o.dropBoxArchive))
	
	C_LONGINT:C283($expectedBkUpSize)
	C_TEXT:C284($ignore)  //file name to skip over
	
	$expectedBkUpSize:=$pathConfigs_o.expectedSize  // 500 MB used when testing the sent file size and current date
	$ignore:=$pathConfigs_o.ignore
	
	
	Case of 
		: ($originalsFolder_o=Null:C1517)
			utl_Logfile("ams_backup.log"; "FAILED. Original path invalid. ")
			
		: ($mirrorsFolder_o=Null:C1517)
			utl_Logfile("ams_backup.log"; "FAILED. Mirror path invalid. ")
			
		: ($dropboxFolder_o=Null:C1517)
			utl_Logfile("ams_backup.log"; "FAILED. DropBox path invalid. ")
			
		Else 
			
			
			C_COLLECTION:C1488($allFilesInFolder_c; $backupFiles_c; $mirrorFiles_c; $dropBoxFiles_c; $exists_c)
			C_OBJECT:C1216($file_o; $copy_o)
			
			
			//now sync local and dropbox to the backups folder,
			$allFilesInFolder_c:=$originalsFolder_o.files(fk ignore invisible:K87:22)
			$backupFiles_c:=$allFilesInFolder_c.query("fullName # :1"; $ignore).orderBy("fullName")  //only the 4BK and 4BL
			
			If ($backupFiles_c.length>1)  //wait for both the .4BK and .4BL, then "let's do it!", else try later
				
				$mirrorFiles_c:=$mirrorsFolder_o.files(fk ignore invisible:K87:22)
				$dropBoxFiles_c:=$dropboxFolder_o.files(fk ignore invisible:K87:22)
				
				For each ($file_o; $backupFiles_c)
					
					If (Position:C15("4BK"; $file_o.fullName)>0)  //this is the important file, make sure it weighs enuff
						
						If ($file_o.size<$expectedBkUpSize)  //give it some time to complete, when backup begins a file name touched in preperation
							utl_Logfile("ams_backup.log"; "!!!! "+$file_o.fullName+" Is Too Small, File size:  "+String:C10($file_o.size))
							EMAIL_Sender("[Bkup2Dbx] "+$file_o.fullName+" Is Too Small, delay activated"; "File size: "+String:C10($file_o.size); "Check the backup"; ArkyktAmsHelpEmail)
						End if 
						
					End if 
					
					//first the local mirror
					$exists_c:=$mirrorFiles_c.query("fullName = :1"; $file_o.fullName)
					If ($exists_c.length=0)  //this is something new, lets make some copies
						utl_Logfile("ams_backup.log"; "Copying (with overwrite) "+$file_o.fullName+" to "+$pathConfigs_o.backupMirrors)
						$copy_o:=$file_o.copyTo($mirrorsFolder_o; fk overwrite:K87:5)  //this is the mirror copy
					End if 
					
					//now the dropbox mirror
					$exists_c:=$dropBoxFiles_c.query("fullName = :1"; $file_o.fullName)
					If ($exists_c.length=0)  //this is something new, lets make some copies
						utl_Logfile("ams_backup.log"; "Copying (with overwrite) "+$file_o.fullName+" to "+$pathConfigs_o.dropBoxArchive)
						$copy_o:=$file_o.copyTo($dropboxFolder_o; fk overwrite:K87:5)  //this is the mirror copy
					End if 
					
					
				End for each 
				
				C_DATE:C307($nextBackupDate)
				C_TIME:C306($nextBackupTime)
				GET BACKUP INFORMATION:C888(Next backup date:K54:3; $nextBackupDate; $nextBackupTime)
				utl_Logfile("ams_backup.log"; "COMPLETED. Will check again after next backup. "+TS2iso(TSTimeStamp($nextBackupDate; $nextBackupTime)))
				
			End if 
			
	End case 
	
Else 
	utl_Logfile("ams_backup.log"; "FAILED. 'config_Backup.json' file missing or invalid.")
	EMAIL_Sender("[Bkup2Dbx] "+"'config_Backup.json' file missing or invalid."; ""; "Make copies of the backup"; ArkyktAmsHelpEmail)
End if 

ON ERR CALL:C155("")