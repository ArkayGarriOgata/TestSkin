//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: Calendar_InitArea - Created `v1.0.0-PJK (12/22/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 


C_POINTER:C301($1; $pGantt)
$pGantt:=$1

$ttBaseURL:=Get 4D folder:C485(Current resources folder:K5:16)+"TaskCal"+GetPlatformFileDelimiter
$ttPath:=$ttBaseURL+"taskCal.html"
DOCUMENT TO BLOB:C525($ttPath; $obData)
$ttHTMLCode:=BLOB to text:C555($obData; UTF8 text without length:K22:17)
$ttBaseURL:="file://"+Convert path system to POSIX:C1106($ttBaseURL)

WA OPEN URL:C1020($pGantt->; $ttBaseURL+"taskCal.html")
ARRAY TEXT:C222($filters; 0)
ARRAY BOOLEAN:C223($AllowDeny; 0)

APPEND TO ARRAY:C911($filters; "*_gantt*")
APPEND TO ARRAY:C911($AllowDeny; False:C215)
WA SET URL FILTERS:C1030($pGantt->; $filters; $AllowDeny)
