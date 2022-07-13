//%attributes = {}
//Method:  Quik_OM_PopUp(patPopUp)
//Description:  This method handles the PopUps

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patPopUp)
	C_TEXT:C284($tPopUp)
	C_LONGINT:C283($nTable; $nField)
	
	$patPopUp:=$1
	
	RESOLVE POINTER:C394($patPopUp; $tPopUp; $nTable; $nField)
	
End if   //Done Initialize

Case of   //PopUp
		
	: ($tPopUp="Quik_atEntry_Group")
		
		Quik_Entry_Group
		
	: ($tPopUp="Quik_atEntry_Category")
		
		Quik_Entry_Category
		
End case   //Done popup
