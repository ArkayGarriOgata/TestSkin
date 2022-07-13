//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: GetPlatformFileDelimiter - Created `v1.0.0-PJK (12/22/15)

// Modified by: Mel Bohince (4/28/20) eliminate _O_PLATFORM_PROPERTIES($xlPlatform)

C_TEXT:C284($0)
C_LONGINT:C283($xlPlatform)
C_BOOLEAN:C305($fserver)
C_TEXT:C284($1)
$0:=""

$fserver:=False:C215  //v1.0.2-WCT added
If (Count parameters:C259>0)  //v1.0.2-WCT added to get the correct delimiter for the server
	$fServer:=($1="Server")  //v1.0.2-WCT added 
End if   //v1.0.2-WCT added 


Case of   //v1.0.2-WCT added  was if statement
	: (Is macOS:C1572)  // added case
		$0:=":"
		
	: (Is Windows:C1573)  //Windows
		$0:="\\"
		
	Else 
		$0:=":"
End case   //v1.0.2-WCT added 