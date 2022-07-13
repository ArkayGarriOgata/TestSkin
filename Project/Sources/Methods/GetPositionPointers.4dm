//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 01/31/13, 09:24:18
// ----------------------------------------------------
// Method: GetPositionPointers
// ----------------------------------------------------

C_LONGINT:C283($i)
ARRAY POINTER:C280(apPositions; 0)
ARRAY POINTER:C280(apVars; 0)
ARRAY POINTER:C280(apHide; 0)

For ($i; 1; 16)
	APPEND TO ARRAY:C911(apPositions; Get pointer:C304("cPosition"+String:C10($i)))
End for 

For ($i; 1; 16)
	APPEND TO ARRAY:C911(apVars; Get pointer:C304("t"+String:C10($i)))
End for 

For ($i; 1; 16)
	APPEND TO ARRAY:C911(apHide; Get pointer:C304("cbHide"+String:C10($i)))
End for 