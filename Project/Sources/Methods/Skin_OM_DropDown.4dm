//%attributes = {}
/*
Method:  Skin_OM_DropDown(tDropDown)
Description:  This method will handle dropdowns
*/

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tDropDownName)
	
	$tDropDownName:=$1
	
End if   //Done Initialize

Case of   //Dropdown
		
	: ($tDropDownName="Skin_Demo_atFamily")
		
		Skin_Demo_Family
		
End case   //Done Dropdown
