//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/26/12, 09:09:35
// ----------------------------------------------------
// Method: RequestBigger
// Description:
// Looks like the built in Alert but holds 2 lines of static text.
// $1 = Static text for the user.
// $2 = Window title, Optional
// ----------------------------------------------------

C_TEXT:C284(tMsg; $1; tVar; $0; $tWinTitle; $2)

tMsg:=$1
tVar:=""

If (Count parameters:C259=2)
	$tWinTitle:=$2
Else 
	$tWinTitle:="Alert"
End if 

CenterWindow(380; 130; 4; $tWinTitle)
DIALOG:C40("RequestBiggerDialog")
CLOSE WINDOW:C154

$0:=tVar