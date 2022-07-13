//%attributes = {}
//Method:  Core_Database_BackupAlert({tEmail})
//Description:  This method will run and alert if the backup is not running
// Added by: Garri Ogata (12/18/20) Check backup files
// Modified by: Garri Ogata (9/7/21) added ArkyktAmsHelpEmail
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tEmail)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_BOOLEAN:C305($bBackUpSet)
	
	C_DATE:C307($dLastBackupDate; $dNextBackupDate)
	C_LONGINT:C283($nLastBackupStatus)
	C_TEXT:C284($tLastBackupStatus)
	C_TIME:C306($hLastBackupTime; $hNextBackupTime)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tEmail:=ArkyktAmsHelpEmail
	
	If ($nNumberOfParameters>=1)
		$tEmail:=$1
	End if 
	
	$bBackUpSet:=False:C215
	
	$dLastBackupDate:=!00-00-00!
	$dNextBackupDate:=!00-00-00!
	$nLastBackupStatus:=0
	$tLastBackupStatus:=CorektBlank
	$hLastBackupTime:=?00:00:00?
	$hNextBackupTime:=?00:00:00?
	
End if   //Done Initialize

GET BACKUP INFORMATION:C888(Last backup date:K54:1; $dLastBackupDate; $hLastBackupTime)

GET BACKUP INFORMATION:C888(Next backup date:K54:3; $dNextBackupDate; $hNextBackupTime)

GET BACKUP INFORMATION:C888(Last backup status:K54:2; $nLastBackupStatus; $tLastBackupStatus)

Case of   //Backup set
		
	: ($dNextBackupDate=!00-00-00!)
	: ($hNextBackupTime<?23:00:00?)  //No sooner than 11:00 PM
	: ($hNextBackupTime>?23:50:59?)  //No later than 11:50 PM
		
	Else   //All set
		
		$bBackUpSet:=True:C214
		
End case   //Done backup set

If (Not:C34($bBackUpSet))
	
	$tMessage:="The back up on the server is not set."+CorektCR
	$tMessage:=$tMessage+"1. From the 4D Server Administration window click on the Maintenance button"+CorektCR
	$tMessage:=$tMessage+"2. In the back up section click the Preferences... button."+CorektCR
	$tMessage:=$tMessage+"3. On Scheduler tab Set Automatic Backup to Every Day and the time at 23:30."+CorektCR
	$tMessage:=$tMessage+"4. On Configuration tab check only Data file."+CorektCR
	$tMessage:=$tMessage+"5. On Backup & Restore tab use default settings."+CorektCR
	$tMessage:=$tMessage+"6. Click on OK and your done."+CorektCR
	
	EMAIL_Sender("Need to set automatic backup"; "Steps to setup automatic backup:"; $tMessage; $tEmail)
	
End if 
