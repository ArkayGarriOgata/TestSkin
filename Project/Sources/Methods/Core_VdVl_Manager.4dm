//%attributes = {}
//Method:  Core_VdVl_Manager(tPhase)
//Description:  This method will handle form objects

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	$tPhase:=$1
	
End if   //Done initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		OBJECT SET ENABLED:C1123(Core_nVdVl_Save; False:C215)
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		OBJECT SET ENABLED:C1123(Core_nVdVl_Save; True:C214)
		
	: (($tPhase="Core_VdVl_Find") | ($tPhase="Core_VdVl_HList"))
		
		OBJECT SET ENABLED:C1123(Core_nVdVl_Save; False:C215)
		
	: (($tPhase="Core_VdVl_Find") | ($tPhase="Core_VdVl_HList"))
		
		OBJECT SET ENABLED:C1123(Core_nVdVl_Save; False:C215)
		
	: ($tPhase="VerifySave")
		
		OBJECT SET ENABLED:C1123(Core_nVdVl_Save; False:C215)
		
		Case of   //Verified 
				
			: (Core_tVdVl_Category=CorektBlank)
			: (Core_tVdVl_Identifier=CorektBlank)
			: (Size of array:C274(Core_atVdVl_Identifier)=0)
				
			Else 
				
				OBJECT SET ENABLED:C1123(Core_nVdVl_Save; True:C214)
				
		End case   //Done verified
		
End case   //Done phase
