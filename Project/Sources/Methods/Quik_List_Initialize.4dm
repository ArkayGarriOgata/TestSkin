//%attributes = {}
//Method:  Quik_List_Initialize(tPhase})
//Description:  This method will inititlaize the values for the
//  Quik_List form.

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	C_LONGINT:C283($nItemReference; $nReport)
	
	$tPhase:=$1
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		Quik_List_Initialize(CorektPhaseClear)
		
		Quik_List_LoadHList
		
		Quik_List_Manager
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		GET LIST ITEM:C378(CorenHList1; *; $nItemReference; $tName)
		
		$nReport:=Find in array:C230(Quik_atList_Name; $tName)
		Quik_tList_QuickKey:=CorektBlank
		
		Case of 
				
			: ($nItemReference=0)
			: ($nReport=CoreknNoMatchFound)
				
			Else 
				
				Quik_tList_QuickKey:=Quik_atList_QuickKey{$nReport}
				
		End case 
		
		Quik_List_Manager
		
	: ($tPhase=CorektPhaseClear)
		
		Quik_tList_QuickKey:=CorektBlank
		
End case   //Done phase
