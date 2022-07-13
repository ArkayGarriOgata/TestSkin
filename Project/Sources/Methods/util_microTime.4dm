//%attributes = {}

// util_microTime(true)
//
// Desription: 
// Gets the Statistical Mean of an Array
//
// Parameters:
// $1: Boolean to Select Format/Precision
// Results:
// $0: Seconds passed since midnight January 1, 1970 UTC in Text Format
// ----------------------------------------------------
C_BOOLEAN:C305($1; $format_b)
C_TEXT:C284($0; $time_t)

If (Count parameters:C259=1)
	$format_b:=$1
Else 
	$format_b:=True:C214
End if 

$phpOK:=PHP Execute:C1058(""; "microtime"; $time_t; $format_b)
If ($phpOK)
	$0:=$time_t
Else 
	$0:="0"
End if 
