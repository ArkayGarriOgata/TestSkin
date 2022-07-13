//%attributes = {}
//Method:  Arcv_OM_Button(pnButton)
//Description:  This method handles the button

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pnButton)
	C_TEXT:C284($tButtonName)
	C_LONGINT:C283($nTable; $nField)
	
	$pnButton:=$1
	
	RESOLVE POINTER:C394($pnButton; $tButtonName; $nTable; $nField)
	
End if   //Done Initialize

Case of   //Button
		
	: ($tButtonName="Arcv_nView_Excel")
		
		Arcv_View_Excel
		
	: ($tButtonName="Arcv_nView_Import")
		
		Arcv_View_Import
		
	: ($tButtonName="Arcv_nView_OnLoad")
		
		Arcv_View_OnLoad
		
End case   //Done button
