//%attributes = {}
//Method:  Rprt_OM_PopUp(tPopUp)
//Description:  This method handles the PopUps

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPopUp)
	
	$tPopUp:=$1
	
End if   //Done Initialize

Case of   //PopUp
		
	: ($tPopUp="Rprt_atEntry_Group")
		
		Rprt_Entry_Group
		
	: ($tPopUp="Rprt_atEntry_Category")
		
		Rprt_Entry_Category
		
End case   //Done popup
