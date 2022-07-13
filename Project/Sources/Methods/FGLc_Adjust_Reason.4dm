//%attributes = {}
//Method:  FGLc_Adjust_Reason(tPhase{;pOption})
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
		
	: ($tPhase="FGLc_Adjust_Location")
		
		FGLc_atAdjust_Reason:=Find in array:C230(FGLc_atAdjust_Reason; $pOption1->)
		
		FGLc_tAdjust_Reason:=FGLc_atAdjust_Reason{FGLc_atAdjust_Reason}
		FGLc_atAdjust_Reason{0}:=FGLc_atAdjust_Reason{FGLc_atAdjust_Reason}
		
	: ($tPhase="FGLc_Adjust_Negative")
		
		FGLc_tAdjust_Reason:=FGLc_Infer_ReasonT
		
		FGLc_atAdjust_Reason:=Find in array:C230(FGLc_atAdjust_Reason; FGLc_tAdjust_Reason)
		FGLc_atAdjust_Reason{0}:=FGLc_atAdjust_Reason{FGLc_atAdjust_Reason}
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		FGLc_tAdjust_Reason:=FGLc_atAdjust_Reason{FGLc_atAdjust_Reason}
		
	: ($tPhase=CorektPhaseInitialize)
		
		FGLc_Adjust_Reason(CorektPhaseClear)
		
		APPEND TO ARRAY:C911(FGLc_atAdjust_Reason; "Straight from rack")
		APPEND TO ARRAY:C911(FGLc_atAdjust_Reason; "Straight from receiving")
		APPEND TO ARRAY:C911(FGLc_atAdjust_Reason; "Bad label")
		APPEND TO ARRAY:C911(FGLc_atAdjust_Reason; "System Issue")
		APPEND TO ARRAY:C911(FGLc_atAdjust_Reason; "User Error")
		APPEND TO ARRAY:C911(FGLc_atAdjust_Reason; "Case")
		
		FGLc_atAdjust_Reason:=0
		FGLc_atAdjust_Reason{0}:=CorektBlank
		
	: ($tPhase=CorektPhaseClear)
		
		Compiler_FGLc_Array(Current method name:C684; 0)
		
		FGLc_tAdjust_Reason:=CorektBlank
		
End case   //Done phase

FGLc_Adjust_Manager