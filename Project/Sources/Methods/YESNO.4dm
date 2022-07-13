//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: YESNO - Created `v1.0.0-PJK (12/16/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//$1=Message
C_TEXT:C284($1)
C_BOOLEAN:C305($0)
$0:=False:C215

CONFIRM:C162($1; "Yes"; "No")
$0:=(OK=1)