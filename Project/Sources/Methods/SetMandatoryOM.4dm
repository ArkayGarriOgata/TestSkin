//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/24/13, 14:54:00
// ----------------------------------------------------
// Method: SetMandatoryOM
// Description:
// This MUST be in the object method of the field set with SetMandatory.
// Set the object to respond to the Form Events On Getting Focus and On Losing Focus.
// $2 MUST be the same text that was set in SetMandatory!

// Example:
// Case of 
//  : (Form event=On Getting Focus)
//    SetMandatoryOM (Self;"This is a mandatory field.";"On Getting Focus")

//  : (Form event=On Losing Focus)
//    SetMandatoryOM (Self;"This is a mandatory field.";"On Losing Focus")

// End case 
// ----------------------------------------------------

C_POINTER:C301($pField; $1)
C_TEXT:C284(tText; $2; $tEvent; $3)

$pField:=$1
tText:=$2
$tEvent:=$3

Case of 
	: ($tEvent="On Getting Focus")
		If ($pField->=tText)
			$pField->:=""
			SetObjectProperties(""; $pField->; True:C214; ""; True:C214)
		End if 
		
	: ($tEvent="On Losing Focus")
		If ($pField->="")  //User didn't enter anything in this mandatory field, set it back.
			SetMandatory($pField; tText)
			
		End if 
End case 