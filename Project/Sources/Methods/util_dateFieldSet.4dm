//%attributes = {}
// Method: util_dateFieldSet () -> 
// ----------------------------------------------------
// by: mel: 11/18/04, 15:05:28
// ----------------------------------------------------
// Description:
// use Modified(field) instead     ?? what is the meaning of this comment??
// Updates:

// ----------------------------------------------------
C_BOOLEAN:C305($0)
C_POINTER:C301($1)
$currentValue:=$1->
$oldValue:=Old:C35($fieldPtr->)
If ($currentValue#!00-00-00!) & ($oldValue=!00-00-00!)
	$0:=True:C214
Else 
	$0:=False:C215
End if 