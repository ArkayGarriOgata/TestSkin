//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/07/06, 12:32:42
// ----------------------------------------------------
// Method: util_ComboBoxAction(->array{;any})
// Description
// returns the choosen or enteered value of the combo box
// so that it can be assigned to a field
// optional param is the default if entered value not in array
//otherwise restricted to values in the array

// Parameter pointer to combobox array
// ----------------------------------------------------
C_LONGINT:C283($hit)
C_POINTER:C301($1)
C_TEXT:C284($2; $0)  //

$hit:=Find in array:C230($1->; ($1->{0}+"@"))
If ($hit>0)
	$1->{0}:=$1->{$hit}
Else 
	If (Count parameters:C259=1)
		$1->{0}:=""
	Else 
		$1->{0}:=$2
	End if 
End if 
$0:=$1->{0}
