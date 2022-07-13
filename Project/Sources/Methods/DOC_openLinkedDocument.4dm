//%attributes = {}
// Method: DOC_openLinkedDocument () -> 
// ----------------------------------------------------
// by: mel: 09/09/04, 12:23:55
// ----------------------------------------------------

C_LONGINT:C283($0; $errCode)
C_TEXT:C284($1; $volume)
ARRAY TEXT:C222($aVolumes; 0)

$errCode:=0
$volume:=util_TextParser(6; $1; Character code:C91(<>DELIMITOR); 13)
$volume:=util_TextParser(1)

VOLUME LIST:C471($aVolumes)
$hit:=Find in array:C230($aVolumes; $volume)
If ($hit>-1)
	If (Test path name:C476($1)=1)
		zwStatusMsg("Please Wait"; "Opening: "+$1)
		$errCode:=util_Launch_External_App($1)
		Case of 
			: ($errCode=-43)
				BEEP:C151
				ALERT:C41($1+Char:C90(13)+" is not available, contact Imaging.")
				
			: ($errCode#0)
				BEEP:C151
				ALERT:C41("Error# "+String:C10($errCode)+" occurred opening '"+$1+"' contact Systems.")
			Else 
				zwStatusMsg("OPENED"; $1)
		End case 
		
	Else 
		BEEP:C151
		ALERT:C41($1+" is no longer available in this directory. Choose 'Find...' under Finders File me"+"nu to look for it."; "I'll Try")
		$errCode:=-2
	End if 
Else 
	BEEP:C151
	ALERT:C41("You must mount the "+$volume+" volume first. Choose 'Connect to Server...' under Finders Go menu."; "No Problem")
	$errCode:=-1
End if 

$0:=$errCode
$volume:=util_TextParser
ARRAY TEXT:C222($aVolumes; 0)