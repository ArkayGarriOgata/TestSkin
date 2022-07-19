//%attributes = {}
/*
Method: Skin_Entr_Initialize(tPhase)
Description: This method will initialize the Skin_Entr form
*/

If (True:C214)  // Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	$tPhase:=$1
	
End if   // Done initialize 

Case of   // Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		Skin_Entr_Initialize(CorektPhaseClear)
		
	: ($tPhase=CorektPhaseClear)
		
		Form:C1466.tSource:=CorektBlank
		Form:C1466.cSources:=CorektBlank
		
		Skin_Entr_Manager
		
End case   //Done phase