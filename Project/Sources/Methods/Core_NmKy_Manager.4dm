//%attributes = {}
//Method: Core_NmKy_Manager(tPhase)
//Description: This method will manage buttons

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	C_BOOLEAN:C305($bVisible)
	
	$tPhase:=$1
	
	$bVisible:=False:C215
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		$bVisible:=User in group:C338(Current user:C182; "RoleSuperUser")
		
		OBJECT SET VISIBLE:C603(*; "NewNameValue"; $bVisible)
		OBJECT SET VISIBLE:C603(*; "Core_tNmKy_NewName"; $bVisible)
		OBJECT SET VISIBLE:C603(*; "NewKeyValue"; $bVisible)
		OBJECT SET VISIBLE:C603(*; "Core_tNmKy_NewKey"; $bVisible)
		
		OBJECT SET VISIBLE:C603(*; "Core_nNmKy_Delete"; $bVisible)
		OBJECT SET VISIBLE:C603(*; "Rectangle"; $bVisible)
		
End case   //Done phase