//%attributes = {}
//Method:  Rprt_Pick_Manager(tPhase)
//Description:  This method will handle form objects

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	$tPhase:=$1
	
End if   //Done initialize

Case of   //Phase
		
	: ($tPhase=("Rprt_Pick_CriterionSet"+"PopUp"))
		
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_Title0"; True:C214)
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_atValue0"; True:C214)
		
	: ($tPhase=("Rprt_Pick_CriterionSet"+"Enterable"))
		
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_Title0"; True:C214)
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_tValue0"; True:C214)
		
	: ($tPhase=("Rprt_Pick_CriterionSet"+"Start Date"))
		
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_StartDate"; True:C214)
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_dStart"; True:C214)
		
	: ($tPhase=("Rprt_Pick_CriterionSet"+"End Date"))
		
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_EndDate"; True:C214)
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_dEnd"; True:C214)
		
	: ($tPhase=("Rprt_Pick_CriterionSet"+CorektPhaseClear))
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_Title0"; False:C215)
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_atValue0"; False:C215)
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_tValue0"; False:C215)
		
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_StartDate"; False:C215)
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_dStart"; False:C215)
		
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_EndDate"; False:C215)
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_dEnd"; False:C215)
		
	: ($tPhase=("Rprt_Pick_Initialize"+CorektPhaseAssignVariable))
		
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_tDescription"; True:C214)
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_tLastRun"; True:C214)
		
	: ($tPhase=CorektPhaseInitialize)
		
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_Title0"; False:C215)
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_atValue0"; False:C215)
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_tValue0"; False:C215)
		
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_StartDate"; False:C215)
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_dStart"; False:C215)
		
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_EndDate"; False:C215)
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_dEnd"; False:C215)
		
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_tDescription"; False:C215)
		OBJECT SET VISIBLE:C603(*; "Rprt_Pick_tLastRun"; False:C215)
		
End case   //Done phase
