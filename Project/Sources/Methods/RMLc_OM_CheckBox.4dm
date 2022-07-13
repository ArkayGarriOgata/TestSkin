//%attributes = {}
//Method:  RMLc_OM_CheckBox(tCheckBoxName)
//Description:  This method handles check boxes

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tCheckBoxName)
	
	$tCheckBoxName:=$1
	
End if   //Done initialize

Case of   //Checkbox
		
	: (Position:C15("RMLc_Pick_n"; $tCheckBoxName)>0)
		
		RMLc_Pick_Manager($tCheckBoxName)
		
End case   //Done checkbox
