//%attributes = {}
//Method:  UsSp_OM_ListBox(pListBox)
//Description:  This method handles the button

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pListBox)
	C_TEXT:C284($tListBox)
	C_LONGINT:C283($nTable; $nField)
	
	$pListBox:=$1
	
	RESOLVE POINTER:C394($pListBox; $tListBox; $nTable; $nField)
	
End if   //Done Initialize

Case of   //ListBox
		
	: ($tListBox="FGLc_abAdjust_Negative")
		
		FGLc_Adjust_Negative(CorektPhaseAssignVariable)
		
	: ($tListBox="FGLc_abAdjust_Location")
		
		FGLc_Adjust_Location(CorektPhaseAssignVariable)
		
End case   //Done ListBox
