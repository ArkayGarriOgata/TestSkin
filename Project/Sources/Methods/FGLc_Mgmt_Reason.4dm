//%attributes = {}
//Method:  FGLc_Mgmt_Reason(tPhase{;pOption})
//Description:  This method handles initializing values

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	C_POINTER:C301($2; $pOption)
	
	C_LONGINT:C283($nNumberOfParameters)
	
	$tPhase:=$1
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=2)
		$pOption1:=$2
	End if 
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		Form:C1466.editEntity.Reason:=FGLc_atMgmt_Reason{FGLc_atMgmt_Reason}
		
	: ($tPhase=CorektPhaseInitialize)
		
		FGLc_Mgmt_Reason(CorektPhaseClear)
		
		APPEND TO ARRAY:C911(FGLc_atMgmt_Reason; "CycleCount")
		APPEND TO ARRAY:C911(FGLc_atMgmt_Reason; "Entry Error")
		APPEND TO ARRAY:C911(FGLc_atMgmt_Reason; "Reject")
		APPEND TO ARRAY:C911(FGLc_atMgmt_Reason; "Return")
		APPEND TO ARRAY:C911(FGLc_atMgmt_Reason; "Samples")
		APPEND TO ARRAY:C911(FGLc_atMgmt_Reason; "Scrapped at Customer")
		APPEND TO ARRAY:C911(FGLc_atMgmt_Reason; "Scrapped at Arkay")
		APPEND TO ARRAY:C911(FGLc_atMgmt_Reason; "SubAssembly")
		APPEND TO ARRAY:C911(FGLc_atMgmt_Reason; "Sold")
		APPEND TO ARRAY:C911(FGLc_atMgmt_Reason; "Physical Inventory")
		
		SORT ARRAY:C229(FGLc_atMgmt_Reason; >)
		
		FGLc_atMgmt_Reason:=0
		FGLc_atMgmt_Reason{0}:=CorektBlank
		
	: ($tPhase=CorektPhaseClear)
		
		Compiler_FGLc_Array(Current method name:C684; 0)
		
End case   //Done phase
