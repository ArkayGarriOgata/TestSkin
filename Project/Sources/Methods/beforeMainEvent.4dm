//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: beforeMainEvent
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

C_TEXT:C284($user)

$user:=Current user:C182
FORM GOTO PAGE:C247(2)

If (<>TEST_VERSION)
	SetObjectProperties("test@"; -><>NULL; True:C214)
Else 
	SetObjectProperties("test@"; -><>NULL; False:C215)
End if 

If (Not:C34(User in group:C338($user; "Administration")))
	OBJECT SET ENABLED:C1123(<>ibAdmin; False:C215)
Else 
	OBJECT SET ENABLED:C1123(<>ibAdmin; True:C214)
End if 

If (Current user:C182="Designer")
	OBJECT SET ENABLED:C1123(<>ibAdmin; True:C214)
End if 

If (Not:C34(User in group:C338($user; "AccountManager")))
	OBJECT SET ENABLED:C1123(<>ibCC; False:C215)
Else 
	OBJECT SET ENABLED:C1123(<>ibCC; True:C214)
End if 

If (Not:C34(User in group:C338($user; "Estimators")))
	OBJECT SET ENABLED:C1123(<>ibEst; False:C215)
Else 
	OBJECT SET ENABLED:C1123(<>ibEst; True:C214)
End if 

If (Not:C34(User in group:C338($user; "RMinventory")))
	OBJECT SET ENABLED:C1123(<>ibRM; False:C215)
Else 
	OBJECT SET ENABLED:C1123(<>ibRM; True:C214)
End if 

If (Not:C34(User in group:C338($user; "FGinventory")))
	OBJECT SET ENABLED:C1123(<>ibFG; False:C215)
Else 
	OBJECT SET ENABLED:C1123(<>ibFG; True:C214)
End if 

If (Not:C34(User in group:C338($user; "Purchasing")))
	OBJECT SET ENABLED:C1123(<>ibPO; False:C215)
Else 
	OBJECT SET ENABLED:C1123(<>ibPO; True:C214)
End if 

If (Not:C34(User in group:C338($user; "Requisitions")))  //6/24/97 cs chnged access level
	OBJECT SET ENABLED:C1123(<>ibReq; False:C215)
Else 
	OBJECT SET ENABLED:C1123(<>ibReq; True:C214)
End if 

OBJECT SET ENABLED:C1123(<>ibAddr; False:C215)
If (User in group:C338($user; "Vendors"))
	OBJECT SET ENABLED:C1123(<>ibAddr; True:C214)
End if 
If (User in group:C338($user; "Addresses"))
	OBJECT SET ENABLED:C1123(<>ibAddr; True:C214)
End if 
If (User in group:C338($user; "Contacts"))
	OBJECT SET ENABLED:C1123(<>ibAddr; True:C214)
End if 

If (Not:C34(User in group:C338($user; "Customers")))
	OBJECT SET ENABLED:C1123(<>ibCust; False:C215)
Else 
	OBJECT SET ENABLED:C1123(<>ibCust; True:C214)
End if 

If (User in group:C338(Current user:C182; "SalesManager")) | (User in group:C338(Current user:C182; "RoleSuperUser"))
	OBJECT SET ENABLED:C1123(<>ibSale; True:C214)
Else 
	OBJECT SET ENABLED:C1123(<>ibSale; False:C215)
End if 

If (Not:C34(User in group:C338($user; "Jobs")))
	OBJECT SET ENABLED:C1123(<>ibJob; False:C215)
Else 
	OBJECT SET ENABLED:C1123(<>ibJob; True:C214)
End if 

If (Not:C34(User in group:C338($user; "CustomerOrdering")))
	OBJECT SET ENABLED:C1123(<>ibOrd; False:C215)
	OBJECT SET ENABLED:C1123(<>ibEDI; False:C215)
Else 
	OBJECT SET ENABLED:C1123(<>ibOrd; True:C214)
	OBJECT SET ENABLED:C1123(<>ibEDI; True:C214)
End if 

If (Not:C34(User in group:C338($user; "RoleQA")))
	OBJECT SET ENABLED:C1123(<>ibQA; False:C215)
Else 
	OBJECT SET ENABLED:C1123(<>ibQA; True:C214)
End if 

Case of 
	: (User in group:C338($user; "RoleAccounting"))
		OBJECT SET ENABLED:C1123(bPjt; True:C214)
	: (User in group:C338($user; "RoleCartonDesign"))
		OBJECT SET ENABLED:C1123(bPjt; True:C214)
	: (User in group:C338($user; "RoleCostAccountant"))
		OBJECT SET ENABLED:C1123(bPjt; True:C214)
	: (User in group:C338($user; "RoleCustomerService"))
		OBJECT SET ENABLED:C1123(bPjt; True:C214)
	: (User in group:C338($user; "RoleEstimator"))
		OBJECT SET ENABLED:C1123(bPjt; True:C214)
	: (User in group:C338($user; "RoleManagementTeam"))
		OBJECT SET ENABLED:C1123(bPjt; True:C214)
	: (User in group:C338($user; "RoleSalesman"))
		OBJECT SET ENABLED:C1123(bPjt; True:C214)
	: (User in group:C338($user; "RolePlanner"))
		OBJECT SET ENABLED:C1123(bPjt; True:C214)
	Else 
		OBJECT SET ENABLED:C1123(bPjt; False:C215)
End case 

util_ForceQuitUsers