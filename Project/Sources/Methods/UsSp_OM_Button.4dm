//%attributes = {}
//Method:  UsSp_OM_Button(pnButton)
//Description:  This method handles the button

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pnButton)
	C_TEXT:C284($tButtonName)
	C_LONGINT:C283($nTable; $nField)
	
	$pnButton:=$1
	
	RESOLVE POINTER:C394($pnButton; $tButtonName; $nTable; $nField)
	
End if   //Done Initialize

Case of   //Button
		
	: ($tButtonName="UsSp_nEntry_OnLoad")
		
		UsSp_Entry_OnLoad
		
	: ($tButtonName="UsSp_nEntry_Send")
		
		UsSp_Entry_Send
		
	: ($tButtonName="UsSp_nEntry_Attachment")
		
		UsSp_Entry_Attachment
		
End case   //Done button
