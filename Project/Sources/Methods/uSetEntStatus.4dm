//%attributes = {"publishedWeb":true}
// Method: uSetEntStatus
// Description:
// Set all fields to specified enterability
// Example: uSetEntStatus(»[CUSTOMER];true)
// ----------------------------------------------------

C_POINTER:C301($1)  //pointer to file
C_BOOLEAN:C305($2)  //enterable status
C_LONGINT:C283($i; $FileNo)

If (Count parameters:C259=2)
	$FileNo:=Table:C252($1)
	For ($i; 1; Get last field number:C255($1))
		OBJECT SET ENTERABLE:C238((Field:C253($FileNo; $i))->; $2)
	End for 
Else 
	BEEP:C151
	ALERT:C41("System Error: Incorrect parameters passed to (P) uSetEntStatus)")
End if 