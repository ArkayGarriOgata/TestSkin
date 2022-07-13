//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 03/16/11, 10:51:28
// ----------------------------------------------------
// Method: User_GetAccess
// Description:
// Show records that user can access
// ----------------------------------------------------

C_TEXT:C284($1; $user)
ARRAY TEXT:C222(aCustName; 0)

$user:=$1

QUERY:C277([Users_Record_Accesses:94]; [Users_Record_Accesses:94]UserInitials:1=$user)
$numAccesses:=Records in selection:C76([Users_Record_Accesses:94])
If ($numAccesses>0)
	pattern_PassThru(->[Users_Record_Accesses:94])
	ViewSetter(3; ->[Users_Record_Accesses:94])
	
Else 
	BEEP:C151
	uConfirm($user+" has not been given access to anything."; "OK"; "Help")
End if 