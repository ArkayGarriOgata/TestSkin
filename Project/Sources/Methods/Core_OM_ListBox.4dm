//%attributes = {}
//Method:  Core_OM_ListBox(pListBox)
//Description:  This method handles the ListBox

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pListBox)
	C_TEXT:C284($tListBoxName)
	
	C_LONGINT:C283($nTable; $nField)
	
	$pListBox:=$1
	
	RESOLVE POINTER:C394($pListBox; $tListBoxName; $nTable; $nField)
	
End if   //Done Initialize

Case of   //ListBox
		
	: (Position:C15("Core_atVdVl"; $tListBoxName)>0)  //Any Core_VdVl listbox
		
		Core_VdVl_ListBoxEvent($pListBox)
		
	: (Position:C15("Core_atNmKy"; $tListBoxName)>0)  //Any Core_atNmKy listbox
		
		Core_NmKy_ListBoxEvent($pListBox)
		
	: (Position:C15("Pick"; $tListBoxName)>0)  //Any Pick list array
		
		Core_Pick_ListBox
		
End case   //Done ListBox
