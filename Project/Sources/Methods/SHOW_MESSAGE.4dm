//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: SHOW_MESSAGE - Created `v1.0.0-PJK (12/19/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 
//$1=Init, Update, Close
//$2=Message Text
C_TEXT:C284($1; $2)
Case of 
	: ($1="Init")
		NewWindow(300; 80; 6; 0; "")
		GOTO XY:C161(1; 0)
		MESSAGE:C88($2)
		
	: ($1="Update")
		GOTO XY:C161(1; 0)
		MESSAGE:C88($2)
		
	: ($1="Close")
		CLOSE WINDOW:C154
End case 