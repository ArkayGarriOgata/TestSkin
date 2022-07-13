//%attributes = {}
//Method:  Tgsn_OM_Button(pnButton)
//Description:  This method handles the button

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pnButton)
	C_TEXT:C284($tButtonName)
	C_LONGINT:C283($nTable; $nField)
	
	$pnButton:=$1
	
	RESOLVE POINTER:C394($pnButton; $tButtonName; $nTable; $nField)
	
End if   //Done Initialize

Case of   //Button
		
	: ($tButtonName="Tgsn_nPrGb_SendPipedInvoice")
		
		Tgsn_PrGb_SendPipedInvoice
		
	: ($tButtonName="Tgsn_nVerify_OnLoad")
		
		Tgsn_Verify_OnLoad
		
	: ($tButtonName="Tgsn_Verify_Send")
		
		Tgsn_Verify_Send
		
End case   //Done button
