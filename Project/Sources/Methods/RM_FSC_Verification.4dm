//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 06/04/14, 11:55:13
// ----------------------------------------------------
// Method: RM_FSC_Verification
// Description
// 
//
// Parameters
// ----------------------------------------------------


C_TEXT:C284($1)

If (Count parameters:C259=0)
	
	$pid:=New process:C317("RM_FSC_Verification"; <>lMidMemPart; "FSC Verification"; "init")
	If (False:C215)
		RM_FSC_Verification
	End if 
	
	
Else 
	Case of 
		: ($1="init")
			RM_isCertified_FSC_orSFI("verify")
	End case 
End if 