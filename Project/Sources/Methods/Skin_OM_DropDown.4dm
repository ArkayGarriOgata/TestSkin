//%attributes = {}
/*
Method:  Skin_OM_DropDown(tDropDown)
Description:  This method will handle dropdowns

*/

If (True:C214)  //Initialize
	
	var ($1; $tDropDownName : Text)
	
	
	var ($nTable; $nField : )
	
	$patDropDown:=$1
	
	RESOLVE POINTER:C394($patDropDown; $tDropDownName; $nTable; $nField)
	
End if   //Done Initialize

Case of   //Dropdown
		
	: ($tDropDownName="UsSp_atEntry_Category")
		
		UsSp_Entry_Category
		
End case   //Done Dropdown
