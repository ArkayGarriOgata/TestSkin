//%attributes = {}
// Method:  Core_ServerUp(oServer)
// By: Garri Ogata @ 11/03/20, 08:38:25
// Added by: Garri Ogata (12/15/20) Change to login successful instead of server down
// Description:  This method sends an email if server is down
//  This runs on a seperate server and checks if it can
//.  log into the server. Usually it is called from the database
//.  Method - On server StartUp as follows

//.     C_OBJECT($oServer)

//.     $oServer:=New object()

//.     $oServer.bStartProcess:=True
//.     $oServer.tDistributionList:="garri.ogata@arkay.com"
//.     $oServer.tName:="aMs"
//.     $oServer.tHost:="192.168.1.62"
//.     $oServer.tPort:="19812"
//.     $oServer.tUser:="Designer"
//.     $oServer.tPassword:="1147"

//      Core_ServerUp($oServer)

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oServer)
	
	C_TEXT:C284($tCurrentMethodName)
	C_TEXT:C284($tProcessName)
	
	C_TEXT:C284($tSubjectSuccess)
	C_TEXT:C284($tBodyHeaderSuccess)
	C_TEXT:C284($tBodySuccess)
	
	C_TEXT:C284($tSubjectFail)
	C_TEXT:C284($tBodyHeaderFail)
	C_TEXT:C284($tBodyFail)
	
	C_LONGINT:C283($nDelay1Minute)
	C_LONGINT:C283($nProcessID)
	
	C_BOOLEAN:C305($bLoggedIn)
	C_BOOLEAN:C305($bTriedOnce)
	
	$oServer:=$1
	
	$tCurrentMethodName:=Current method name:C684
	$tProcessName:=$tCurrentMethodName+$oServer.tName
	
	$tSubjectSuccess:="[UsSp] - *** "+$oServer.tName+" logged in SUCCESSFULLY ***"  //[UsSp] tells EMAIL_Sender to not confirm sending email when running from a client
	$tBodyHeaderSuccess:=$oServer.tName+" logged in successfully"
	$tBodySuccess:="Logged in successful. Please verify aMs batch client."
	
	$tSubjectFail:="[UsSp] - *** "+$oServer.tName+" logging in FAILED ***"  //[UsSp] tells EMAIL_Sender to not confirm sending email when running from a client
	$tBodyHeaderFail:=$oServer.tName+" could not login. Please verify the server."
	$tBodyFail:="Make sure to use the document 900-701 aMsRestarting to restart the server and assure everything is done properly."
	
	$nDelay1Minute:=1*60*60  //Convert to Ticks
	$nProcessID:=0
	
	$bLoggedIn:=True:C214
	$bTriedOnce:=False:C215
	
End if   //Done Initialize

If ($oServer.bStartProcess)  //Start process
	
	$oServer.bStartProcess:=False:C215
	
	$nProcessID:=New process:C317($tCurrentMethodName; <>lMinMemPart; $tProcessName; $oServer; *)
	
Else   //Run process
	
	utl_Logfile($tProcessName+".Log"; "Started running and will check every minute.")
	
	$nProcessID:=Current process:C322
	
	While (Not:C34(<>fQuit4D))  //Quit
		
		ON ERR CALL:C155("Core_ServerUpError")
		
		SQL LOGIN:C817(\
			"IP:"+$oServer.tHost+CorektColon+$oServer.tPort; \
			$oServer.tUser; $oServer.tPassword; *)
		
		If (OK=1)  //Server is running
			
			SQL LOGOUT:C872
			
			If (Not:C34($bLoggedIn))
				
				EMAIL_Sender($tSubjectSuccess; $tBodyHeaderSuccess; $tBodySuccess; $oServer.tDistributionList)
				
				utl_Logfile($tProcessName+".Log"; $tSubjectSuccess+" on "+String:C10(Current date:C33(*))+" at "+String:C10(Current time:C178(*)))
				
			End if 
			
			$bLoggedIn:=True:C214
			$bTriedOnce:=False:C215
			
		Else   //server is down
			
			$bLoggedIn:=False:C215
			
			EMAIL_Sender($tSubjectFail; $tBodyHeaderFail; $tBodyFail; $oServer.tDistributionList)
			
			utl_Logfile($tProcessName+".Log"; $tSubjectFail+" on "+String:C10(Current date:C33(*))+" at "+String:C10(Current time:C178(*)))
			
			If (Not:C34($bTriedOnce))  //Try one more time
				
				$bTriedOnce:=True:C214
				
			Else   //Tried twice and failed
				
				DELAY PROCESS:C323($nProcessID; $nDelay1Minute*10)
				
			End if   //Done try one more time
			
		End if   //Done server is running
		
		ON ERR CALL:C155(CorektBlank)
		
		DELAY PROCESS:C323($nProcessID; $nDelay1Minute)  //Wait 1 minute
		
	End while   //Done quit
	
	utl_Logfile($tProcessName+".Log"; "Ended"; "Ended on "+String:C10(Current date:C33(*))+" at "+String:C10(Current time:C178(*)))
	
End if   //Done start process
