//%attributes = {}
// Method: RmTr_OM_Button
// Description: This method handles on the buttons for [Raw_Materials_Transactions]

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pnButton)
	C_TEXT:C284($tButtonName)
	C_LONGINT:C283($nTable; $nField)
	
	$pnButton:=$1
	
	RESOLVE POINTER:C394($pnButton; $tButtonName; $nTable; $nField)
	
End if   //Done initialize

Case of   //Button
		
	: ($tButtonName="RmTr_nFoil_OnLoad")
		
		RmTr_Foil_OnLoad
		
	: ($tButtonName="RmTr_nFoil_Save")
		
		RmTr_Foil_Save
		
End case   //Done button
