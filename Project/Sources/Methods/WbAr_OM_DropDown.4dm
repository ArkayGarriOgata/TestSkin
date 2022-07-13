//%attributes = {}
//Method:  WbAr_OM_DropDown($tDropDownName)
//Description:  This method handles the dropdowns for WbAr

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tDropDownName)
	
	$tDropDownName:=$1
	
End if   //Done initialize

Case of   //Dropdown
		
	: ($tDropDownName="WbAr_Video_atFilePathName")
		
		WbAr_Video_FilePathName
		
End case   //Done dropdown