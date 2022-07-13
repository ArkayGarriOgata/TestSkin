//%attributes = {"invisible":true,"shared":true}
// Method: Core_ListBox_DeselectAll (pabListBox)
// Description: Deselects all rows

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pabListBox)
	C_BOOLEAN:C305($bFalse)
	
	$pabListBox:=$1
	$bFalse:=False:C215
	
End if   //Done Initialize

Core_Array_FillWithValue($pabListBox; ->$bFalse)

REDRAW:C174($pabListBox->)