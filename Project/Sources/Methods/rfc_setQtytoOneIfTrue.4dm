//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/17/08, 15:14:51
// ----------------------------------------------------
// Method: rfc_setQtytoOneIfTrue

// ----------------------------------------------------

C_POINTER:C301($1; $2; $3)

If ($1->)
	$2->:=1
	GOTO OBJECT:C206($2->)
Else 
	$2->:=0
End if 

If (Count parameters:C259=3)
	If ($2->=1)
		rfc_taskCheckBox($3; "set-one")
	Else 
		rfc_taskCheckBox($3; "clear-one")
	End if 
End if 