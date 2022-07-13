//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/24/13, 14:41:45
// ----------------------------------------------------
// Method: SetMandatory
// Description:
// Sets the text in $1 to $2 and makes it light red.
// When the field gets the focus the red text is deleted.
// This is a visual clue that the field is mandatory.
// See the method, SetMandatoryOM for instructions on setting
//  the object method.
// ----------------------------------------------------

C_POINTER:C301($pField; $1)
C_TEXT:C284($tText; $2)

$pField:=$1
$tText:=$2

If (($pField->=$tText) | ($pField->=""))
	OBJECT SET RGB COLORS:C628($pField->; 0x00FF7F7F; 0x00FFFFFF)
	$pField->:=$tText
End if 