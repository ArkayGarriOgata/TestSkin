// ----------------------------------------------------
// Form Method: [zz_control].RM_pi_Tag
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------
// Modified by: MelvinBohince (1/11/22) validate the po entered is for an inventoried item

Case of 
	: (Form event code:C388=On Load:K2:1)
		LIST TO ARRAY:C288("UOMs"; aUOM)
		SetObjectProperties(""; ->sCriterion2; True:C214; ""; True:C214)
		SetObjectProperties(""; ->rReal1; True:C214; ""; False:C215)
		SetObjectProperties(""; ->sCriterion5; True:C214; ""; False:C215)
		SetObjectProperties(""; ->tText; True:C214; ""; False:C215)
		SetObjectProperties(""; ->sCriterion3; True:C214; ""; False:C215)
		SetObjectProperties(""; ->sCriterion4; True:C214; ""; False:C215)
		READ ONLY:C145([zz_control:1])
		ALL RECORDS:C47([zz_control:1])
		C_LONGINT:C283(highTag; lowTag)
		highTag:=[zz_control:1]PhyInvTagHighNumber:50
		lowTag:=[zz_control:1]PhyInvTagLowNumber:49
		REDUCE SELECTION:C351([zz_control:1]; 0)
		
		sCriterion3:="Roanoke"
		
		
End case 