//%attributes = {}
//Method:  Help_OM_Button(tButtonName)
//Description: This method handles buttons in the Help module

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tButtonName)
	$tButtonName:=$1
	
End if   //Done initialize

Case of   //Button
		
	: ($tButtonName="Help_Entr_nSave")
		
		Help_Entr_Save
		
	: ($tButtonName="Help_Entr_nDelete")
		
		Help_Entr_Delete
		
	: ($tButtonName="Help_Entr_nClear")
		
		Help_Entr_Clear
		
	: ($tButtonName="Help_Entr_nOnLoad")
		
		Help_Entr_OnLoad
		
	: ($tButtonName="Help_Entr_nPathName")
		
		Help_Entr_Path
		
	: ($tButtonName="Help_View_nOnLoad")
		
		Help_View_OnLoad
		
	: ($tButtonName="Help_Entr_nEntry")
		
		Help_View_New
		
End case   //Done button