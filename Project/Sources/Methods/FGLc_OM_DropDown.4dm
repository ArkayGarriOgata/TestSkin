//%attributes = {}
//Method:  FGLc_OM_DropDown(patDropDown)
//Description:  This method handles the button

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patDropDown)
	C_TEXT:C284($tDropDownName)
	C_LONGINT:C283($nTable; $nField)
	
	$patDropDown:=$1
	
	RESOLVE POINTER:C394($patDropDown; $tDropDownName; $nTable; $nField)
	
End if   //Done Initialize

Case of   //Dropdown
		
	: ($tDropDownName="FGLc_atMgmt_Reason")
		
		Case of   //Form event
				
			: (Form event code:C388=On Load:K2:1)
				
				FGLc_Mgmt_Reason(CorektPhaseClear)
				
			: (Form event code:C388=On Data Change:K2:15)
				
				FGLc_Mgmt_Reason(CorektPhaseAssignVariable)
				
		End case   //Done form event
		
	: ($tDropDownName="FGLc_atAdjust_Reason")
		
		FGLc_Adjust_Reason(CorektPhaseAssignVariable)
		
End case   //Done Dropdown
