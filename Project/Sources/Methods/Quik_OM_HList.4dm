//%attributes = {}
//Method:  Quik_OM_HList (pHList;tFormName)
//Description:  This method runs the code for the HLists in the Quick module

If (True:C214)  //Initialize 
	
	C_POINTER:C301($1; $pHList)
	C_TEXT:C284($2; $tFormName)
	
	C_TEXT:C284($tHListName)
	C_LONGINT:C283($nTable; $nField)
	C_LONGINT:C283($nFormEvent)
	
	$pHList:=$1
	$tFormName:=$2
	
	RESOLVE POINTER:C394($pHList; $tHListName; $nTable; $nField)
	
	$nFormEvent:=Form event code:C388
	
End if   //Done Initialize

Case of   //What form and HList
		
	: (($tFormName="Quik_List") & ($tHListName="CorenHList1"))
		
		Case of   //Folder
				
			: (Core_HList_IsFolderB(->CorenHList1))  //Its a folder
				
				Quik_List_Initialize(CorektPhaseClear)
				
				Quik_List_Manager
				
			Else   //Item
				
				Quik_List_Initialize(CorektPhaseAssignVariable)
				
				If ((Current user:C182="Designer") & ($nFormEvent=On Double Clicked:K2:5))  //Can edit
					
					Quik_Dialog_Entry(Quik_tList_QuickKey)
					
					Quik_List_LoadHList
					
					Quik_List_Manager
					
				End if   //Done can edit
				
		End case   //Done folder
		
End case   //Done what form and HList