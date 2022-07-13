//%attributes = {"executedOnServer":true}
//see util_BackupToDropBox_EOS instead, compression is too slow and doesn't reduce that much diskspace
///*v18
//  // Method: util_SendBackupZip   ( ) ->
//  // By: Mel Bohince @ 04/01/21, 17:52:15
//  // Description
//  // move ams backup files to dropbox, then move them out of the source folder

//dependencies:
//util_JSON_ObjFromResourceFolder 
//helpers(for config setup): 
//util_JSON_CreateConfig 
//util_JSON_ObjToResourceFolder 

//Path on the ams server:
//external volume mounted on Desktop like"/Users/mel/Desktop/DailyBackupVolume/Daily_4BK4BL"
//DailyBackupVolume-+(example)
// | 
//+-Daily Backup(this is the 4D Backup config destination)
// | ---aMs-data[172].4BL
// | ---aMs-data[173].4BK
// | 
//+-Old Backups(holding for old local backups)
// | ---aMs-data[171].4BL
// | ---aMs-data[172].4BK
// | ....

//Dropbox destination will be"aMsBackup"+$timestamp+".zip"in path like
//"/Users/mel/Dropbox/Documents/arkay"
//when unzipped it will create the Daily Backup folder with the.4BK and .4BL

//*/

//wait till time, or just tack it on the daily batch loop


If (False:C215)  //test with
	//SETUP (once on server):
	util_JSON_CreateConfig  //set up config file the first time, run on the server in 4D Mono, will be set in the server's Resource folder
	// then, from a client call
	util_SendBackupZip("config_archive")
End if 

//include a timestamp in the destination name if overlay is not wanted, currently they are overlayn and dbx handles versions
C_TEXT:C284($timestamp; $archiveName)
If (False:C215)  //increment
	$timestamp:=Replace string:C233(Substring:C12(Timestamp:C1445; 1; 16); ":"; "")  //2016-12-12T13:31:29.478Z to 2016-12-12T133129
Else   //overlay
	$timestamp:=""
End if 

C_LONGINT:C283($expectedBkUpSize)
$expectedBkUpSize:=500000000  // 500 MB used when testing the sent file size and current date

$archiveName:="aMsDailyBku"+$timestamp+".zip"  //archive's name
//$archiveName:="aMsDailyBku_"++".zip"  //keep versions


C_OBJECT:C1216($source_o; $destination_o; $status_o; $sentFolder_o; $paths_o)
$paths_o:=util_JSON_ObjFromResourceFolder("config_archive")
If ($paths_o#Null:C1517)
	
	//contents of this named folder will be in the zip archives payload
	$source_o:=Folder:C1567(Convert path system to POSIX:C1106($paths_o.from))
	If ($source_o#Null:C1517)
		
		//path to the local Dropbox folder that is the offsite target
		$destination_o:=File:C1566(Convert path system to POSIX:C1106($paths_o.to+$archiveName))
		If ($destination_o#Null:C1517)
			
			$status_o:=ZIP Create archive:C1640($source_o; $destination_o)
			BEEP:C151
			
			If ($status_o.success)  //move the contents just zipped to another folder, reload for next run
				
				If ($destination_o.size<$expectedBkUpSize)
					//send email
				End if 
				
				//move contents of Daily_4BK4BL to Sent folder
				$sentFolder_o:=Folder:C1567(Convert path system to POSIX:C1106($paths_o.sent))
				
				C_COLLECTION:C1488($backupFiles_c)
				$backupFiles_c:=$source_o.files(fk ignore invisible:K87:22)
				C_OBJECT:C1216($file_o)
				
				For each ($file_o; $backupFiles_c)
					$file_o:=$file_o.moveTo($sentFolder_o)
				End for each 
				BEEP:C151
				
			Else 
				ALERT:C41("FAILED. "+String:C10($status_o.status)+" "+$status_o.statusText)
			End if 
			
		Else 
			ALERT:C41("FAILED. Destination file invalid.")
		End if 
		
	Else 
		ALERT:C41("FAILED. Source folder missing or invalid.")
	End if 
	
Else 
	ALERT:C41("FAILED. 'config_archive.json' file missing or invalid.")
End if 


