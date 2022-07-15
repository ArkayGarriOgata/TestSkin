//%attributes = {}
//Method:  Skin_OM_CheckBox(tCheckBox)
//Description: This method handles chexkboxes in the Skin module

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tCheckBox)
	$tCheckBox:=$1
	
End if   //Done initialize

Case of   //Checkbox
		
	: ($tCheckBox="Skin_Demo_nDisable")
		
		Skin_Demo_Disable
		
End case   //Done checkbox