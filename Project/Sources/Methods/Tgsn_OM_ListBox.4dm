//%attributes = {}
//Method:  Tgsn_OM_ListBox(pnListBox)
//Description:  This method handles the ListBox

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pListBox)
	C_TEXT:C284($tListBoxName)
	
	$pListBox:=$1
	
	RESOLVE POINTER:C394($pListBox; $tListBoxName; $nTable; $nField)
	
End if   //Done Initialize

Case of   //ListBox
		
	: (Position:C15("Verify"; $tListBoxName)>0)  //Any Verify list array
		
		Tgsn_Verify_ListBox
		
End case   //Done ListBox