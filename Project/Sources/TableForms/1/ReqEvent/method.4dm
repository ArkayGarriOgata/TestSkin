// ----------------------------------------------------
// Method: [zz_control].ReqEvent
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	OBJECT SET ENABLED:C1123(*; "approve@"; False:C215)
	
	
	//If (User in group(Current user;"Req_PreApproval"))
	//OBJECT SET ENABLED(rb2;True)
	//OBJECT SET ENABLED(rb4;True)
	//End if 
	
	If (User in group:C338(Current user:C182; "Req_Approval")) | (User in group:C338(Current user:C182; "RoleSuperUser"))
		OBJECT SET ENABLED:C1123(*; "approve@"; True:C214)
		If (Not:C34(User in group:C338(Current user:C182; "RoleSuperUser")))  // Modified by: Mel Bohince (1/8/20) 
			OBJECT SET ENABLED:C1123(*; "NewReq"; False:C215)
		End if 
	End if 
	
	If (<>bButtons)  // Added by: Mark Zinke (2/6/13)
		FORM GOTO PAGE:C247(2)
		GET WINDOW RECT:C443($xlLeft; $xlTop; $xlRight; $xlBottom)
		SET WINDOW RECT:C444($xlLeft; $xlTop; $xlRight; $xlBottom-60)
	End if 
End if 