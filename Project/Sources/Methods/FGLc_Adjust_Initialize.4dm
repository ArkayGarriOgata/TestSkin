//%attributes = {}
//Method:  FGLc_Adjust_Initialize(tPhase)
//Description:  This method handles initializing values

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	$tPhase:=$1
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		FGLc_Adjust_Initialize(CorektPhaseClear)
		
		FGLc_Adjust_Negative(CorektPhaseInitialize)
		
		FGLc_Adjust_Reason(CorektPhaseInitialize)
		
		FGLc_Adjust_Manager
		
	: ($tPhase=CorektPhaseClear)
		
		FGLc_tAdjust_Change:=CorektBlank
		
		Compiler_FGLc_Array(Current method name:C684; 0)
		
End case   //Done phase