//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/01/13, 16:54:03
// ----------------------------------------------------
// Method: CtlCtrGetArrays
// Description:
// Returns an array containing elements of the listbox that are selected by the user.
// $1 = Pointer to the Listbox
// $2 = Pointer to the Listbox column array. Must be the longint array with record number in it.
// $3 = Array to return the results. Must be a longint array.
// ----------------------------------------------------

C_POINTER:C301($pListBox; $1; $pColumnArray; $2; $pResultArray; $3)
C_LONGINT:C283($i)

$pListBox:=$1
$pColumnArray:=$2
$pResultArray:=$3

For ($i; 1; Size of array:C274($pListBox->))
	If ($pListBox->{$i})
		APPEND TO ARRAY:C911($pResultArray->; $pColumnArray->{$i})
	End if 
End for 