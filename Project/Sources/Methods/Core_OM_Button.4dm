//%attributes = {}
//Method:  Core_OM_Button(pnButton)
//Description:  This method handles the button

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pnButton)
	C_TEXT:C284($tButtonName)
	C_LONGINT:C283($nTable; $nField)
	
	$pnButton:=$1
	
	RESOLVE POINTER:C394($pnButton; $tButtonName; $nTable; $nField)
	
End if   //Done Initialize

Case of   //Button
		
	: ($tButtonName="Core_nVdVl_Remove")
		
		Core_VdVl_Remove
		
	: ($tButtonName="Core_nVdVl_Add")
		
		Core_VdVl_Add
		
	: ($tButtonName="Core_nVdVl_Delete")
		
		Core_VdVl_Delete(Current form name:C1298)
		
	: ($tButtonName="Core_nVdVl_New")
		
		Core_VdVl_New
		
	: ($tButtonName="Core_nVdVl_Save")
		
		Core_VdVl_Save
		
	: ($tButtonName="Core_nVdVl_OnLoad")
		
		Core_VdVl_OnLoad
		
	: ($tButtonName="Core_nNmKy_OptionPick")
		
		Core_NmKy_OptionPick
		
	: ($tButtonName="Core_nNmKy_Option")
		
		Core_NmKy_Option
		
	: ($tButtonName="Core_nNmKy_Report")
		
		Core_NmKy_Report
		
	: ($tButtonName="Core_nNmKy_OnLoad")
		
		Core_NmKy_OnLoad
		
	: ($tButtonName="Core_nViewArray_OnLoad")
		
		Core_ViewArray_OnLoad
		
	: ($tButtonName="Core_nPick_OnLoad")
		
		Core_Pick_OnLoad
		
	: ($tButtonName="Core_nPrompt_PopUp")
		
		Core_Prompt_PopUp
		
	: ($tButtonName="Core_nPrompt_OnLoad")
		
		Core_Prompt_OnLoad
		
	: ($tButtonName="Core_nWindow_Drag")  //This object can be used to drag any window
		
		Core_Window_Drag
		
	: ($tButtonName="Core_nWindow_Resize")  //This object can be used to drag any window
		
		Core_Window_Resize
		
End case   //Done button
