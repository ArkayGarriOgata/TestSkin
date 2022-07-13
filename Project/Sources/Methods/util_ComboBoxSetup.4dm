//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/07/06, 18:49:00
// ----------------------------------------------------
// Method: util_ComboBoxSetup(->combo_array;field)
// Description
// sets up the combo box to match the existing field value
//
// Parameters
// ----------------------------------------------------

If (Length:C16($2)>0) & ($2#"0")
	$hit:=Find in array:C230($1->; ($2+"@"))
	If ($hit>-1)
		$1->{0}:=$1->{$hit}
		$1->:=$hit
	Else 
		$1->{0}:=$2
		$1->:=0
	End if 
Else 
	$1->{0}:=""
	$1->:=0
End if 