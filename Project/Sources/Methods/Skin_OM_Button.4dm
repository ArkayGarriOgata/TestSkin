//%attributes = {}
//Method:  Skin_OM_Button(tButtonName)
//Description: This method handles buttons in the Skin module

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tButtonName)
	$tButtonName:=$1
	
End if   //Done initialize

Case of   //Button
	: ($tButtonName="Skin_Entr_nCancel")
		
		Skin_Entr_Clear
		
	: ($tButtonName="Skin_Entr_nOK")
		
		Skin_Entr_Confirm
		
	: ($tButtonName="Skin_Entr_nSource")
		
		Skin_Entr_Source
		
	: ($tButtonName="Skin_Entr_nOnLoad")
		
		Skin_Entr_OnLoad
		
End case   //Done button