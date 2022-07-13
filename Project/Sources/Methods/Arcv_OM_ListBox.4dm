//%attributes = {}
//Method:  Arcv_OM_ListBox
//Description:  This method handles the ListBox

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pListBox)
	C_TEXT:C284($tListBoxName)
	
	$pListBox:=$1
	
	RESOLVE POINTER:C394($pListBox; $tListBoxName; $nTable; $nField)
	
End if   //Done Initialize

Case of   //ListBox
		
	: ($tListBoxName="Arcv_abView_Table")  //Any Pick list array
		
		Arcv_View_Table
		
End case   //Done ListBox
