//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/24/09, 14:58:36
// ----------------------------------------------------
// Method: cco_set_change_order_type({comparefieldptr1;comparefieldptr2};checkboxfieldptr)
// Description
// tick the checkboxes on the face of the change order
// ----------------------------------------------------

If (changeOrderOpened)
	If (Count parameters:C259=3)
		$test:=($1->#$2->)
		$fieldPtr:=$3
	Else 
		$test:=True:C214
		$fieldPtr:=$1
	End if 
	
	If ($test)
		$fieldPtr->:=True:C214
	End if 
End if 