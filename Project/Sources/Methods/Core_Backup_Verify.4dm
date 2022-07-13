//%attributes = {}
// Method:  Core_Backup_Verify (oBackup)
// By: Garri Ogata @ 11/03/20, 08:38:25
// Description:  This method sends an email if the backup or logfile is not 
//   being saved.
//   This runs as a stored procedure and checks the created on and created at
//   document information

//.  Usually it is called from the database
//.  Method - On server StartUp as follows:

//.     C_OBJECT($oBackup)

//.     $oBackup:=New object()

//.     $oBackup.bStartProcess:=True
//.     $oBackup.tDistributionList:=ArkyktAmsHelpEmail
//.     $oBackup.tPathname:="Macintosh HD:Users:ladmin:Dropbox:ams_bkup:"
//.     $oBackup.tBackup:="AMS Daily Hauppauge Backup.zip"
//.     $oBackup.tLog:="Log File.zip"

//      Core_Backup_Verify($oBackup)

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oBackup)
	
	C_TEXT:C284($tCurrentMethodName)
	C_TEXT:C284($tProcessName)
	
	C_TEXT:C284($tSubject)
	C_TEXT:C284($tBodyHeader)
	C_TEXT:C284($tBody)
	
	C_LONGINT:C283($nDelay1Minute)
	C_LONGINT:C283($nProcessID)
	
	C_OBJECT:C1216($oBackupDataFile)
	C_OBJECT:C1216($oLogFile)
	
	$oBackup:=$1
	
	$tCurrentMethodName:=Current method name:C684
	$tProcessName:=$tCurrentMethodName
	
	$tSubject:="[UsSp] - *** BACKUP IS NOT CURRENT ***"  //[UsSp] tells EMAIL_Sender to not confirm sending email when running from a client
	$tBodyHeader:="Please verify the backup setting and Automator is running."
	$tBody:="Please verify the backup settings: Maintenance|Preferences...|Configuration|Backup File Destination Folder and Log Management folder."+CorektCR
	$tBody:=$tBody+"Make sure they are set to the correct folders.  Also verify Automator is running."
	
	$nDelay1Minute:=1*60*60  //Convert to Ticks
	$nDelay1Hour:=60*$nDelay1Minute
	$nProcessID:=0
	
	$tBackupPathname:=$oBackup.tPathname+$oBackup.tBackup
	$tLogPathname:=$oBackup.tPathname+$oBackup.tLog
	
	$oBackupDataFile:=New object:C1471()
	$oLogFile:=New object:C1471()
	
End if   //Done Initialize

If ($oBackup.bStartProcess)  //Start process
	
	$oBackup.bStartProcess:=False:C215
	
	$nProcessID:=New process:C317($tCurrentMethodName; <>lMinMemPart; $tProcessName; $oBackup; *)
	
Else   //Run process
	
	utl_Logfile($tProcessName+".Log"; "Started running and will check every hour.")
	
	$nProcessID:=Current process:C322
	
	While (Not:C34(<>fQuit4D))  //Quit
		
		ON ERR CALL:C155("Core_Backup_VerifyError")
		
		$bBackupVerified:=False:C215
		
		If (Current time:C178(*)>?23:30:00?)  //After 11:30 PM 
			DELAY PROCESS:C323($nProcessID; $nDelay1Hour)  //wait till after 12:30 PM to run
		End if   //Done after 11:30 PM 
		
		Case of   //Verify
				
			: (Not:C34(Test path name:C476($oBackup.tPathname)=Is a folder:K24:2))  //Verify Path name is good
			: (Not:C34(Core_Document_GetInfoB($tBackupPathname; ->$oBackupDataFile)))  //Verify Backup exists
			: (Not:C34(Core_Document_GetInfoB($tLogPathname; ->$oLogFile)))  //Verify Log exists
			: (Not:C34($oBackupDataFile.dCreatedOn>=Add to date:C393(Current date:C33(*); 0; 0; -1)))  //Verify Backup.zip dCreatedOn is no later than yesterday
			: (Not:C34($oBackupDataFile.rSize>=1000000000))  //Backup.zip>=1GB
			: (Not:C34($oLogFile.hCreatedAt>=(Current time:C178(*)-?00:05:00?)))  //Verify Log.zip hCreatedAt is with in last 5 minutes
				
			Else   //Verified
				
				$bBackupVerified:=True:C214
				
		End case   //Done verify
		
		If (Not:C34($bBackupVerified))  //Backup and/or Logs are not current
			
			EMAIL_Sender($tSubject; $tBodyHeader; $tBody; $oBackup.tDistributionList)
			
			utl_Logfile($tProcessName+".Log"; $tSubject+" on "+String:C10(Current date:C33(*))+" at "+String:C10(Current time:C178(*)))
			
		End if   //Done backup and/or Logs are not current
		
		ON ERR CALL:C155(CorektBlank)
		
		DELAY PROCESS:C323($nProcessID; $nDelay1Hour)  //Check every hour
		
	End while   //Done quit
	
	utl_Logfile($tProcessName+".Log"; "Ended"; "Ended on "+String:C10(Current date:C33(*))+" at "+String:C10(Current time:C178(*)))
	
End if   //Done start process
