//%attributes = {}
// _______
// Method: util_EntityLocked   ( ) ->
// By: Mel Bohince @ 03/08/21, 12:49:56
// Description
// newer style dialog for displaying locked info
// see also util_EntitySelectionLockTest
// ----------------------------------------------------

C_LONGINT:C283($winRef)
C_OBJECT:C1216($formObj; $1)
$formObj:=$1

If (Not:C34(OB Is defined:C1231($formObj; "button")))
	$formObj.button:="Try later"
End if 

If (Not:C34(OB Is defined:C1231($formObj; "message")))
	$formObj.message:="Record in use"
End if 

BEEP:C151
$winRef:=Open form window:C675("LockedRecord"; Movable form dialog box:K39:8)
DIALOG:C40("LockedRecord"; $formObj)
CLOSE WINDOW:C154($winRef)
