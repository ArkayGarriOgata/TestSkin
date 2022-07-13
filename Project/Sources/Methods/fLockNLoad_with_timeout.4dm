//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/19/08, 10:03:46
// ----------------------------------------------------
// Method: fLockNLoad_with_timeout(->[table];logname;timeout_value)
// Description
// like sending fLockNLoad a second and third parameter
//
// Parameters
// ----------------------------------------------------
C_POINTER:C301($1)  //fContinue:=fLockNLoad(»[file])
C_TEXT:C284($2; $logfilename)
$logfilename:=$2
C_LONGINT:C283($3; $timeout_value)
$timeout_value:=$3
C_BOOLEAN:C305($0; $showMsg)
<>fContinue:=True:C214

C_LONGINT:C283($state)
C_TEXT:C284($procName; $userName; $machName; $lockProcess)
C_LONGINT:C283($time; $lockProcNo; $attempts)

If (Locked:C147($1->))
	UNLOAD RECORD:C212($1->)  //in case local procedure has record locked by read only
	READ WRITE:C146($1->)
	LOAD RECORD:C52($1->)  //re load record so that if this is only a 'read only' problem it is now fixed
	
	If ((Locked:C147($1->)) & (<>fContinue))
		LOCKED BY:C353($1->; $lockProcNo; $userName; $machName; $lockProcess)
		PROCESS PROPERTIES:C336(Current process:C322; $procName; $state; $time)
		
		utl_Logfile($logfilename; "Locked: "+Table name:C256($1)+" record incountered, user '"+$userName+"' "+$machName+" doing "+$lockProcess)
		
		$attempts:=0
		While ((Locked:C147($1->)) & (<>fContinue))
			If ($attempts>$timeout_value)
				<>fContinue:=False:C215
				utl_Logfile($logfilename; "Locked: "+Table name:C256($1)+" skipped ")
			End if 
			DELAY PROCESS:C323(Current process:C322; 30)
			LOAD RECORD:C52($1->)
			$attempts:=$attempts+1
		End while 
		
	End if 
	
End if 
$0:=<>fContinue
//