//%attributes = {}
//Method: Core_NmKy_Initialize(tPhase)
//Description: This method will initialize the Core_NmKy table

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	$tPhase:=$1
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		Core_NmKy_Initialize(CorektPhaseClear)
		
		Core_NmKy_Manager($tPhase)
		
	: ($tPhase=CorektPhaseClear)
		
		Compiler_Core_Array(Current method name:C684; 25)
		
		Core_tNmKy_NewName:=CorektBlank
		Core_tNmKy_NewKey:=CorektBlank
		
		Core_nNmKy_OmitZero:=0
		Core_nNmKy_Delete:=0
		
End case   //Done phase