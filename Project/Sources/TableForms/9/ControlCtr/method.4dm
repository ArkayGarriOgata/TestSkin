// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 3/27/00
// ----------------------------------------------------
// Form Method: [Customers_Projects].ControlCtr
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		C_LONGINT:C283(pjt_picker; tc_PjtControlCtr)
		C_TEXT:C284(pjtCustid; pjtId)
		C_TEXT:C284(pjtCustName; pjtName)
		
		ControlCtrLoadTabs(True:C214)  // Added by: Mark Zinke (4/15/13) True means load all the tabs
		pjtCustid:=""
		pjtId:=""
		pjtCustName:=""
		pjtName:=""
		REDUCE SELECTION:C351([Customers_Orders:40]; 0)
		REDUCE SELECTION:C351([Estimates:17]; 0)
		REDUCE SELECTION:C351([Job_Forms:42]; 0)
		OBJECT SET ENABLED:C1123(*; "customerSelected@"; False:C215)
		OBJECT SET ENABLED:C1123(*; "projectSelected@"; False:C215)
		SetObjectProperties("pjtData@"; -><>NULL; False:C215)
		OBJECT SET ENABLED:C1123(bTeam; False:C215)
		
		If (Not:C34(User in group:C338(Current user:C182; "Customers")))
			OBJECT SET ENABLED:C1123(bNewCust; False:C215)
		Else 
			OBJECT SET ENABLED:C1123(bNewCust; False:C215)
		End if 
		
		SetObjectProperties("acctMgr@"; -><>NULL; False:C215)
		SetObjectProperties("planner@"; -><>NULL; False:C215)
		
	: (Form event code:C388=On Unload:K2:2)
		REDUCE SELECTION:C351([Customers_Orders:40]; 0)
		REDUCE SELECTION:C351([Estimates:17]; 0)
		REDUCE SELECTION:C351([Job_Forms:42]; 0)
		If (Is a list:C621(pjt_picker))
			CLEAR LIST:C377(pjt_picker)
		End if 
		<>pjtId:=""
End case 