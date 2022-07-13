// ----------------------------------------------------
// Method: [zz_control]FGEvent
// ----------------------------------------------------


If (Form event code:C388=On Load:K2:1)
	If (Size of array:C274(<>asWIP)=0)
		uInitPopUpsFG  //Added to reduce proc size below 32k
	End if 
	If (Size of array:C274(<>aFGRptPop)=0)
		arrFgReports
	End if 
	
	OBJECT SET ENABLED:C1123(*; "FGX@"; False:C215)
	OBJECT SET ENABLED:C1123(*; "FG_Adjust"; False:C215)
	OBJECT SET ENABLED:C1123(ibNew; False:C215)
	OBJECT SET ENABLED:C1123(ibMod; False:C215)
	OBJECT SET ENABLED:C1123(ibDel; False:C215)
	OBJECT SET ENABLED:C1123(bDummy; False:C215)
	OBJECT SET ENABLED:C1123(bImaging; False:C215)
	OBJECT SET ENABLED:C1123(ibIss; False:C215)
	
	OBJECT SET ENABLED:C1123(bBill; False:C215)
	OBJECT SET ENABLED:C1123(bPU; False:C215)
	
	OBJECT SET ENABLED:C1123(<>ib_delvr_schd; True:C214)
	
	If (User in group:C338(Current user:C182; "Planners"))
		OBJECT SET ENABLED:C1123(ibNew; True:C214)
		OBJECT SET ENABLED:C1123(ibMod; True:C214)
		OBJECT SET ENABLED:C1123(bImaging; True:C214)
		OBJECT SET ENABLED:C1123(ibDel; True:C214)
		OBJECT SET ENABLED:C1123(bDummy; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "Planners")) | (User in group:C338(Current user:C182; "RoleImaging")) | (User in group:C338(Current user:C182; "RoleQA"))
		OBJECT SET ENABLED:C1123(bImaging; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "INV Mgr"))
		OBJECT SET ENABLED:C1123(*; "FGX@"; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "FG_Can_Adjust"))  // Modified by: Mel Bohince (11/1/18) 
		OBJECT SET ENABLED:C1123(*; "FG_Adjust"; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "CustomerService"))
		OBJECT SET ENABLED:C1123(bBill; True:C214)
		OBJECT SET ENABLED:C1123(bPU; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "RoleMaterialHandler")) | (User in group:C338(Current user:C182; "RolePlanner"))
		OBJECT SET ENABLED:C1123(ibIss; True:C214)
	End if 
	
	If (<>PHYSICAL_INVENORY_IN_PROGRESS)
		OBJECT SET ENABLED:C1123(*; "FGX@"; False:C215)
		OBJECT SET ENABLED:C1123(bBill; False:C215)
	End if 
	
	If (<>bButtons)  // Added by: Mark Zinke (2/6/13)
		FORM GOTO PAGE:C247(2)
		GET WINDOW RECT:C443($xlLeft; $xlTop; $xlRight; $xlBottom)
		SET WINDOW RECT:C444($xlLeft; $xlTop; $xlRight; $xlBottom)
	End if 
End if 