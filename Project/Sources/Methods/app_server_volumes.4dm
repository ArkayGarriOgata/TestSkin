//%attributes = {}
// -------
// Method: app_server_volumes   ( ) ->
// By: Mel Bohince @ 10/05/17, 14:25:00
// Description
// log the mounted volumns
// ----------------------------------------------------
// Modified by: Mel Bohince (6/29/18) name changed to "ams daily bkup"
// Modified by: Garri Ogata (9/22/20) changed to send to amshelp@arkay.com.
// Modified by: Garri Ogata (11/11/20) changed to only run if in production
// Modified by: Mel Bohince (6/30/21) option to cutover to new mac server
// Modified by: Garri Ogata (9/7/21) added ArkyktAmsHelpEmail
Compiler_0000_ConstantsToDo

Case of   // Modified by: Mel Bohince (6/30/21) option to cutover to new mac server
	: (Current machine:C483="AMS Server 2018")
		$backUpVolumeName:="amsbackup"
		
	: (Current machine:C483="AMS-NY-2021")
		$backUpVolumeName:="ams_daily_bkup"
		
	Else   //not a production machine
		$backUpVolumeName:=""
End case 


If (Length:C16($backUpVolumeName)>0)  //Only check production// Modified by: Mel Bohince (6/30/21) option to cutover to new mac server
	
	ARRAY TEXT:C222($aVolume; 0)
	C_BOOLEAN:C305($bku_volume_found)
	
	VOLUME LIST:C471($aVolume)
	
	C_LONGINT:C283($i; $numElements)
	$bku_volume_found:=False:C215
	$numElements:=Size of array:C274($aVolume)
	For ($i; 1; $numElements)
		utl_Logfile("server.log"; String:C10($i)+") mounted volume: "+$aVolume{$i})
		If (Position:C15($backUpVolumeName; $aVolume{$i})>0)  //Backup// Modified by: Mel Bohince (6/30/21) option to cutover to new mac server
			utl_Logfile("server.log"; "aMs Backup Volume is mounted ["+$backUpVolumeName+"]")
			$bku_volume_found:=True:C214
		End if 
	End for 
	
	If (Not:C34($bku_volume_found))
		utl_Logfile("server.log"; "aMs Backup Volume Dismounted ["+$backUpVolumeName+"]")
		EMAIL_Sender("aMs Backup Volume Dismounted"; ""; "Go check"; ArkyktAmsHelpEmail)
	End if 
	
End if   //Done only check production
