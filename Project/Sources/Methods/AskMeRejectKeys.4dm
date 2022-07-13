//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/18/12, 13:00:22
// ----------------------------------------------------
// Method: AskMeRejectKeys
// Description:
// A list of rejected values.
// ----------------------------------------------------

C_BOOLEAN:C305($0)
C_TEXT:C284($tValue; $1)

$tValue:=$1
$0:=False:C215

Case of 
	: ($tValue="Today")
	: ($tValue="Yesterday")
	: ($tValue="This Week")
	: ($tValue="Last Week")
	: ($tValue="This Month")
	: ($tValue="Older")
	Else 
		$0:=True:C214
End case 