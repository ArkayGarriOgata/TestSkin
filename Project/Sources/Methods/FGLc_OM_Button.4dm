//%attributes = {}
//Method:  FGLc_OM_Button(pnButton)
//Description:  This method handles the button

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pnButton)
	C_TEXT:C284($tButtonName)
	C_LONGINT:C283($nTable; $nField)
	
	$pnButton:=$1
	
	RESOLVE POINTER:C394($pnButton; $tButtonName; $nTable; $nField)
	
End if   //Done Initialize

Case of   //Button
		
	: ($tButtonName="FGLc_nAdjust_OnLoad")
		
		FGLc_Adjust_Initialize(CorektPhaseInitialize)
		
	: ($tButtonName="FGLc_nAdjust_AskMe")
		
		FGLc_Adjust_AskMe
		
	: ($tButtonName="FGLc_nAdjust_ApplyChange")
		
		FGLc_Adjust_ApplyChange
		
End case   //Done button
