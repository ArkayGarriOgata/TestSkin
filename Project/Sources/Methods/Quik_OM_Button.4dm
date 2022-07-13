//%attributes = {}
//Method:  Quik_OM_Button(pnButton)
//Description:  This method handles the button

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pnButton)
	C_TEXT:C284($tButtonName)
	C_LONGINT:C283($nTable; $nField)
	
	$pnButton:=$1
	
	RESOLVE POINTER:C394($pnButton; $tButtonName; $nTable; $nField)
	
End if   //Done Initialize

Case of   //Button
		
	: ($tButtonName="Quik_nEntry_Export")
		
		Quik_Entry_Export
		
	: ($tButtonName="Quik_nEntry_Delete")
		
		Quik_Entry_Delete
		
	: ($tButtonName="Quik_nEntry_Save")
		
		Quik_Entry_Save
		
	: ($tButtonName="Quik_nEntry_Name")
		
		Quik_Entry_Name
		
	: ($tButtonName="Quik_nEntry_OnLoad")
		
		Quik_Entry_OnLoad(Quik_tList_QuickKey)
		
	: ($tButtonName="Quik_nList_Entry")
		
		Quik_List_Entry
		
	: ($tButtonName="Quik_nList_Excel")
		
		Quik_List_Excel(Quik_tList_QuickKey)
		
	: ($tButtonName="Quik_nList_OnLoad")
		
		Quik_List_OnLoad
		
End case   //Button
