//%attributes = {}
//Method:  Arcv_OM_Variable(pVariable)
//Description:  This method handles the button

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pVariable)
	C_TEXT:C284($tVariable)
	C_LONGINT:C283($nTable; $nField)
	
	$pVariable:=$1
	
	RESOLVE POINTER:C394($pVariable; $tVariable; $nTable; $nField)
	
End if   //Done Initialize

Case of   //Variable
		
	: ($tVariable="Arcv_tView_Find")
		
		Arcv_View_Find
		
End case   //Done variable