//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 12/05/05, 13:07:01
// ----------------------------------------------------
// Method: User_ZebraPreferences
// Description
// 
//
// Parameters
// ----------------------------------------------------
C_TEXT:C284($1; $0; $2)
$0:=""
If (Count parameters:C259=1)
	READ ONLY:C145([Users:5])
	QUERY:C277([Users:5]; [Users:5]Initials:1=$1)
	
Else 
	READ WRITE:C146([Users:5])
	QUERY:C277([Users:5]; [Users:5]Initials:1=$1)
	[Users:5]zebra_preferences:59:=$2
	SAVE RECORD:C53([Users:5])
End if 

$0:=[Users:5]zebra_preferences:59

REDUCE SELECTION:C351([Users:5]; 0)