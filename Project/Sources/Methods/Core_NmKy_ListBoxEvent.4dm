//%attributes = {}
//Method: Core_NmKy_ListBoxEvent(pListBox)
//Description:  This method handles the listbox entering

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pListBox)
	
	$pListBox:=$1
	
End if   //Done initialize

Core_ListBox_EnterNow($pListBox)
