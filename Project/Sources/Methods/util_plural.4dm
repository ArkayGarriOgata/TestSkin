//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/04/14, 11:27:46
// ----------------------------------------------------
// Method: util_plural
// Description:
// Easy to make words plural or not.
//
// Parameters:
// $1 = Word to modify
// $2 = Value to test
// $0 = Return value
// ----------------------------------------------------

C_TEXT:C284($1; $0)
C_LONGINT:C283($2)

If ($2>1)
	$0:=$1+"s"
Else 
	$0:=$1
End if 