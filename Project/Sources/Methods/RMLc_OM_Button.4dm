//%attributes = {}
//Method:  RMLc_OM_Button(tButtonName)
//Description:  This method will manage buttons for RMLc module

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tButtonName)
	
	$tButtonName:=$1
	
End if   //Done initialize

Case of   //Button
		
	: ($tButtonName="RMLc_nPick_OnLoad")
		
		RMLc_Pick_OnLoad
		
		
End case   //Done button

