//%attributes = {}
// _______
// Method: util_BackupLogFile   ( ) ->
// By: Mel Bohince @ 07/13/21, 13:27:35
// Description
// keep a copy of the .journal file on a local external and the dropbox

// based on util_BackupToDropBox_EOS
// ----------------------------------------------------
// Modified by: Garri Ogata (9/7/21) added ArkyktAmsHelpEmail
Compiler_0000_ConstantsToDo
If (False:C215)  //test with
	//SETUP (once on server):
	util_JSON_CreateConfig3  //set up config file the first time, run on the server in 4D Mono, will be set in the server's Resource folder
	// then call this from On Server Startup
	util_BackupLogFile
End if 


ON ERR CALL:C155("e_BackupLogFileError")  // Modified by: Mel Bohince (7/16/21) 

utl_Logfile("ams_backup.log"; "##############")
utl_Logfile("ams_backup.log"; "Begin archive of ams log files")

C_OBJECT:C1216($originalsFolder_o; $mirrorsFolder_o; $dropboxFolder_o; $pathConfigs_o)

C_LONGINT:C283($lastLogTime)  //only make copies if it is different timestamp on .journal file
$lastLogTime:=0
C_DATE:C307($lastLogDate)
$lastLogDate:=!00-00-00!

Repeat 
	
	If (True:C214)  //do it
		
		$pathConfigs_o:=util_JSON_ObjFromResourceFolder("config_Logfile")
		
		If ($pathConfigs_o#Null:C1517)
			
			//contents of this named folder will be moved to Dropbox and the Mirror folders
			$originalsFolder_o:=Folder:C1567(Convert path system to POSIX:C1106($pathConfigs_o.journalOriginal))
			//this is the local copy for historical reference
			$mirrorsFolder_o:=Folder:C1567(Convert path system to POSIX:C1106($pathConfigs_o.journalMirror))
			//this is the Dropbox folder on the local mac for emergency restores
			$dropboxFolder_o:=Folder:C1567(Convert path system to POSIX:C1106($pathConfigs_o.journalArchive))
			
			C_LONGINT:C283($delayInTicks)
			$delayInTicks:=60*60*$pathConfigs_o.delayInMinutes
			
			C_TEXT:C284($journalsFullName)  //target file name
			$journalsFullName:=$pathConfigs_o.journalFullName
			
			Case of 
				: ($originalsFolder_o=Null:C1517)
					utl_Logfile("ams_backup.log"; "FAILED. journalOriginal path invalid. ")
					
				: ($mirrorsFolder_o=Null:C1517)
					utl_Logfile("ams_backup.log"; "FAILED. journalMirror path invalid. ")
					
				: ($dropboxFolder_o=Null:C1517)
					utl_Logfile("ams_backup.log"; "FAILED. journalDropbox path invalid. ")
					
				: (Length:C16($journalsFullName)=0)
					utl_Logfile("ams_backup.log"; "FAILED. journal's name is invalid. ")
					
				Else 
					
					
					C_COLLECTION:C1488($allFilesInFolder_c)
					C_OBJECT:C1216($file_o; $copy_o)
					
					$allFilesInFolder_c:=$originalsFolder_o.files(fk ignore invisible:K87:22)  // Modified by: Mel Bohince (7/6/21) 
					$backupFiles_c:=$allFilesInFolder_c.query("fullName = :1"; $journalsFullName).orderBy("fullName")  //only the 4BK and 4BL
					
					If ($backupFiles_c.length>0)  // looks like a journal is there, as it should
						
						For each ($file_o; $backupFiles_c)
							If ($lastLogTime#$file_o.modificationTime) | ($lastLogDate#$file_o.modificationDate)  //there has been a change
								$lastLogTime:=$file_o.modificationTime
								$lastLogDate:=$file_o.modificationDate
								
								utl_Logfile("ams_backup.log"; "Copying "+$file_o.fullName+" to "+$pathConfigs_o.journalMirror+" & "+$pathConfigs_o.journalArchive+", interval: "+String:C10($pathConfigs_o.delayInMinutes)+" minutes.")
								
								$copy_o:=$file_o.copyTo($mirrorsFolder_o; fk overwrite:K87:5)  //this is the local copy of the log file
								
								$copy_o:=$file_o.copyTo($dropboxFolder_o; fk overwrite:K87:5)  //this is the Dropbox copy of the log file
								
							Else 
								utl_Logfile("ams_backup.log"; "No change to "+$file_o.fullName+", interval: "+String:C10($pathConfigs_o.delayInMinutes)+" minutes.")
							End if   //there has been a change to the file spec
							
						End for each 
						
					End if 
					
			End case 
			
		Else 
			utl_Logfile("ams_backup.log"; "FAILED. 'config_archive.json' file missing or invalid.")
			EMAIL_Sender("[Bkup2Dbx] "+"'config_Logfile.json' file missing or invalid."; ""; "Check the backup"; ArkyktAmsHelpEmail)
		End if 
		
	End if   //do it
	
	
	DELAY PROCESS:C323(Current process:C322; $delayInTicks)
	
Until (<>fQuit4D)

utl_Logfile("ams_backup.log"; "END ##########")
ON ERR CALL:C155("")
