//%attributes = {}
//Method:  Arcv_View_Initialize(tPhase)
//Description:  This method handles initializing values

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	$tPhase:=$1
	
End if   //Done initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		Arcv_View_Initialize(CorektPhaseClear)
		
		Arcv_View_TableName(CorektPhaseInitialize)
		
	: ($tPhase=CorektPhaseClear)
		
		Arcv_tView_Find:=CorektBlank
		
End case   //Done phase