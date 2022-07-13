//%attributes = {}
//Method: Skin_Demo_Initialize(tPhase)
//Description: This method will initialize the Skin_Demo form

If (True:C214)  // Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	$tPhase:=$1
	
End if   // Done initialize 

Case of   // Phase
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		Skin_Demo_Manager
		
	: ($tPhase=CorektPhaseInitialize)
		
		Skin_Demo_Initialize(CorektPhaseClear)
		
		Skin_Demo_Manager
		
	: ($tPhase=CorektPhaseClear)
		
End case   //Done phase