//%attributes = {}
//Method:  Core_Pick_Select(nRow)
//Description:  This method will select a line in a listbox

If (True:C214)  //Initialization
	
	C_LONGINT:C283($1; $nRow)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_LONGINT:C283($nSelection)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$nRow:=$1
	
	$nSelection:=Choose:C955(Core_oPick.bPickMultiple; lk add to selection:K53:2; lk replace selection:K53:1)
	
	If ($nNumberOfParameters>=2)  //Optional parameters
		$nSelection:=$2
	End if   //Done optional parameters
	
End if   //Done initialization

LISTBOX SELECT ROW:C912(Core_abPick; $nRow; $nSelection)

If (Not:C34(Core_oPick.bPickMultiple))
	
	Core_Array_Clear(->Core_abPick)
	Core_Array_Clear(->Core_abPick_Picked)
	
End if 

Core_abPick{$nRow}:=True:C214
Core_abPick_Picked{$nRow}:=True:C214

Core_ListBox_SetBackground(->Core_abPick; ->Core_abPick_Picked)

OBJECT SET SCROLL POSITION:C906(Core_abPick; $nRow; 2)
