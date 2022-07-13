//%attributes = {}
//Method:  Arcv_OM_DropDown(patDropDown)
//Description:  This method handles the DropDowns

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patDropDown)
	C_TEXT:C284($tDropDownName)
	C_LONGINT:C283($nTable; $nField)
	
	$patDropDown:=$1
	
	RESOLVE POINTER:C394($patDropDown; $tDropDownName; $nTable; $nField)
	
End if   //Done Initialize

Case of   //Dropdown
		
	: ($tDropDownName="Arcv_atView_TableName")
		
		Arcv_View_TableName(CorektPhaseAssignVariable)
		
End case   //Done Dropdown
