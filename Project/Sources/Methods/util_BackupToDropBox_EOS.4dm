//%attributes = {"executedOnServer":true}
// _______
// Method: util_BackupToDropBox_EOS   ( ) ->
// By: Mel Bohince @ 06/29/21, 14:23:24

// Modified by: Mel Bohince (7/8/21) rename files to the old-backups if they already exist
//      also trying to keep the 4BK target on the internal drive to avoid permissions problems,
//      this done by changing the util_JSON_CreateConfig

// Description   *v18 cmds
// COPY the daily-backup and log files to the dropbox and then MOVE to old-backups folder
// from the daily backup, uses config_archive.json for actual paths

// call in on server startup

//    similar to util_SendBackupZip without doing the compression, much faster this way
// ----------------------------------------------------


//dependencies:
//util_JSON_ObjFromResourceFolder 
//helpers(for config setup): 
//util_JSON_CreateConfig 
//util_JSON_ObjToResourceFolder 

//Path on the ams server:
//external volume mounted on Desktop like"/Users/mel/Desktop/DailyBackupVolume/Daily_4BK4BL"
//DailyBackupVolume-+(example)
// | 
//+-daily-backup   (this is the 4D Backup config destination)
// | ---aMs-data[172].4BL
// | ---aMs-data[173].4BK
// | 
//+-old-backups   (holding for old local backups)
// | ---aMs-data[171].4BL
// | ---aMs-data[172].4BK
// | ....

//Dropbox destination will be a path like
//"/Users/mel/Dropbox/Documents/arkay"

//wait till time, or just tack it on the daily batch loop
// Modified by: Garri Ogata (9/7/21) added ArkyktAmsHelpEmail
Compiler_0000_ConstantsToDo
If (False:C215)  //test with
	//SETUP (once on server):
	util_JSON_CreateConfig  //set up config file the first time, run on the server in 4D Mono, will be set in the server's Resource folder
	// then, from a client call
	util_BackupToDropBox_EOS
End if 

utl_Logfile("ams_backup.log"; "##############")
utl_Logfile("ams_backup.log"; "Begin archive of ams backup files")

C_OBJECT:C1216($source_o; $destination_o; $status_o; $sentFolder_o; $config_o)

Repeat 
	
	If (True:C214)  //do it
		
		$config_o:=util_JSON_ObjFromResourceFolder("config_archive")
		
		If ($config_o#Null:C1517)
			
			//contents of this named folder will be moved to Dropbox and the OldBackups folder
			$source_o:=Folder:C1567(Convert path system to POSIX:C1106($config_o.from))
			//this is the Dropbox folder on the local mac
			$destination_o:=Folder:C1567(Convert path system to POSIX:C1106($config_o.to))
			//this is the local copy for historical reference
			$sentFolder_o:=Folder:C1567(Convert path system to POSIX:C1106($config_o.sent))
			
			$journalOriginal_o:=Folder:C1567(Convert path system to POSIX:C1106($config_o.journalOriginal))
			//this is the local copy for historical reference
			$journalDropBox_o:=Folder:C1567(Convert path system to POSIX:C1106($config_o.journalDropbox))
			
			C_LONGINT:C283($expectedBkUpSize; $delayInTicks)
			C_TEXT:C284($ignore)  //file name to skip over
			
			$expectedBkUpSize:=$config_o.expectedSize  // 500 MB used when testing the sent file size and current date
			$delayInTicks:=60*60*$config_o.delayInMinutes
			$ignore:=$config_o.ignore
			
			
			Case of 
				: ($journalOriginal_o=Null:C1517)
					utl_Logfile("ams_backup.log"; "FAILED. journalOriginal path invalid. ")
					
				: ($journalDropBox_o=Null:C1517)
					utl_Logfile("ams_backup.log"; "FAILED. journalDropbox path invalid. ")
					
				: ($source_o=Null:C1517)
					utl_Logfile("ams_backup.log"; "FAILED. Source path invalid. ")
					
				: ($destination_o=Null:C1517)
					utl_Logfile("ams_backup.log"; "FAILED. Destination path invalid. ")
					
				: ($sentFolder_o=Null:C1517)
					utl_Logfile("ams_backup.log"; "FAILED. Sent path invalid. ")
					
				Else 
					
					
					C_COLLECTION:C1488($allFilesInFolder_c; $backupFiles_c)
					C_OBJECT:C1216($file_o; $copy_o)
					
					
					//first deal with the journal aka log file
					$allFilesInFolder_c:=$journalOriginal_o.files(fk ignore invisible:K87:22)  // Modified by: Mel Bohince (7/6/21) 
					If ($allFilesInFolder_c.length>0)  // looks like a journal is there, as it should
						
						For each ($file_o; $allFilesInFolder_c)
							
							If ($file_o.fullName="aMs-data.journal")  //there could be other crap in the folder
								utl_Logfile("ams_backup.log"; "Copying "+$file_o.fullName+" to "+$config_o.journalDropbox+", interval: "+String:C10($config_o.delayInMinutes)+" minutes.")
								$copy_o:=$file_o.copyTo($journalDropBox_o; fk overwrite:K87:5)  //this is the Dropbox copy of the log file
							End if 
							
						End for each 
						
					End if 
					
					
					//now move to the backups folder,
					// Modified by: Mel Bohince (7/8/21) the dbx copy is overlayn, the old-backups copy is renamed if necessary
					$allFilesInFolder_c:=$source_o.files(fk ignore invisible:K87:22)
					$backupFiles_c:=$allFilesInFolder_c.query("fullName # :1"; $ignore)  //only the 4BK and 4BL
					
					If ($backupFiles_c.length>1)  //wait for both the .4BK and .4BL, then "let's do it!", else try later
						
						For each ($file_o; $backupFiles_c)
							
							If (Position:C15("4BK"; $file_o.fullName)>0)  //this is the important file
								
								
								If ($file_o.size<$expectedBkUpSize)  //give it some time to complete, when backup begins a file name touched in preperation
									utl_Logfile("ams_backup.log"; "!!!! "+$file_o.fullName+" Is Too Small, File size:  "+String:C10($file_o.size))
									utl_Logfile("ams_backup.log"; "!!!! Delaying for "+String:C10($config_o.delayInMinutes)+" minutes.")
									EMAIL_Sender("[Bkup2Dbx] "+$file_o.fullName+" Is Too Small, delay activated"; "File size: "+String:C10($file_o.size); "Check the backup"; ArkyktAmsHelpEmail)
									
									DELAY PROCESS:C323(Current process:C322; $delayInTicks)  // Modified by: Mel Bohince (7/8/21) 
								End if 
								
								
							End if 
							
							utl_Logfile("ams_backup.log"; "Copying (with overwrite) "+$file_o.fullName+" to "+$config_o.to)
							$copy_o:=$file_o.copyTo($destination_o; fk overwrite:K87:5)  //this is the Dropbox copy
							
							If (File:C1566($sentFolder_o.path+$file_o.fullName).exists)  //test for duplicate
								
								$newFileName:=$file_o.fullName+"-"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")
								utl_Logfile("ams_backup.log"; "Moving "+$newFileName+" to "+$config_o.sent)
								$copy_o:=$file_o.moveTo($sentFolder_o; $newFileName)  //move with new name
								
							Else   //keep the name
								utl_Logfile("ams_backup.log"; "Moving "+$file_o.fullName+" to "+$config_o.sent)
								$copy_o:=$file_o.moveTo($sentFolder_o)  //get set up for next time by moving this file
							End if 
							
						End for each 
						
						utl_Logfile("ams_backup.log"; "COMPLETED. Will check again in "+String:C10($config_o.delayInMinutes)+" minutes.")
						
						//Else 
						//utl_Logfile ("ams_backup.log";"!!!! backups files have not arrived. ")
					End if 
					
			End case 
			
		Else 
			utl_Logfile("ams_backup.log"; "FAILED. 'config_archive.json' file missing or invalid.")
			EMAIL_Sender("[Bkup2Dbx] "+"'config_archive.json' file missing or invalid."; ""; "Check the backup"; ArkyktAmsHelpEmail)
		End if 
		
	End if   //do it
	
	
	DELAY PROCESS:C323(Current process:C322; $delayInTicks)
	
Until (<>fQuit4D)

utl_Logfile("ams_backup.log"; "END ##########")
