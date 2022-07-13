//%attributes = {}
//Method:  Core_VdVl_ListBoxEvent(pListBox)
//Descripton: This method will handle the ListBox entering

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pListBox)
	
	$pListBox:=$1
	
End if   //Done initialize

Core_ListBox_EnterNow($pListBox)

Core_VdVl_Manager("VerifySave")