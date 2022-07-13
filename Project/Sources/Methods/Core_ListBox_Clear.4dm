//%attributes = {}
//Method:  Core_ListBox_Clear(pListBox)
//Description:  This method will clear a listbox

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pListBox)
	
	$pListBox:=$1
	
End if   //Done initialize

LISTBOX DELETE COLUMN:C830($pListBox->; 1; LISTBOX Get number of columns:C831($pListBox->))

