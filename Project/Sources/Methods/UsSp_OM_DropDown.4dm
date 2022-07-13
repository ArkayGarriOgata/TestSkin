//%attributes = {}
//Method:  UsSp_OM_DropDown(patDropDown)
//Description:  This method handles the button

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patDropDown)
	C_TEXT:C284($tDropDownName)
	C_LONGINT:C283($nTable; $nField)
	
	$patDropDown:=$1
	
	RESOLVE POINTER:C394($patDropDown; $tDropDownName; $nTable; $nField)
	
End if   //Done Initialize

Case of   //Dropdown
		
	: ($tDropDownName="UsSp_atEntry_Category")
		
		UsSp_Entry_Category
		
End case   //Done Dropdown

