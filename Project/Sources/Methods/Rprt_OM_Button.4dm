//%attributes = {}
//Method:  Rprt_OM_Button(tButtonName)
//Description:  This method handles the button

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tButtonName)
	
	$tButtonName:=$1
	
End if   //Done Initialize

Case of   //Button
		
	: ($tButtonName="Rprt_Entry_nAdd")
		
		Rprt_Entry_Add
		
	: ($tButtonName="Rprt_Entry_nRemove")
		
		Rprt_Entry_Remove
		
	: ($tButtonName="Rprt_Entry_nDelete")
		
		Rprt_Entry_Delete
		
	: ($tButtonName="Rprt_Entry_nSave")
		
		Rprt_Entry_Save
		
	: ($tButtonName="Rprt_Entry_nOnLoad")
		
		Rprt_Entry_OnLoad
		
	: ($tButtonName="Rprt_Pick_nEntry")
		
		Rprt_Pick_Entry
		
	: ($tButtonName="Rprt_Pick_nOnLoad")
		
		Rprt_Pick_OnLoad
		
	: ($tButtonName="Rprt_Pick_nViewPro")
		
		Rprt_Pick_ViewPro
		
End case   //Done button