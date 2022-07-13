//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/12/13, 08:44:23
// ----------------------------------------------------
// Method: UtilGetLastChar
// Description:
// Simply returns the last char of a string.
// ----------------------------------------------------

C_TEXT:C284($1)

$0:=Substring:C12($1; Length:C16($1))