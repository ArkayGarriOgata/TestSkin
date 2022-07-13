//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 09/06/06, 16:59:35
// ----------------------------------------------------
// Method: beforeCust
// Description:
// Replace old way, see src prior to 11/06/06
// ----------------------------------------------------

If (Not:C34(User_AllowedCustomer([Customers:16]ID:1; ""; "via cust:"+[Customers:16]Name:2)))
	bDone:=1
	CANCEL:C270
End if 

ARRAY TEXT:C222(aSalesReps; 0)  //11/18/94
OBJECT SET ENABLED:C1123(bDelete; False:C215)
OBJECT SET ENABLED:C1123(bOpenContact; False:C215)
OBJECT SET ENABLED:C1123(bdelRel2; False:C215)
OBJECT SET ENABLED:C1123(bOpenAddress; False:C215)
OBJECT SET ENABLED:C1123(bdelRel1; False:C215)
OBJECT SET ENABLED:C1123(bTeam; False:C215)
OBJECT SET ENABLED:C1123(bEmail; False:C215)
SetObjectProperties("DisplayOnly@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)

If (sFile#"Customers")
	SetObjectProperties(""; ->[Customers:16]Name:2; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
End if 

If (([Customers:16]ColorForeground:69=0) & ([Customers:16]ColorBackground:70=0))
	OBJECT SET RGB COLORS:C628(*; "UseColor@"; Foreground color:K23:1; Background color:K23:2)
Else 
	OBJECT SET RGB COLORS:C628(*; "UseColor@"; [Customers:16]ColorForeground:69; [Customers:16]ColorBackground:70)
End if 

If (iMode<=2)
	READ WRITE:C146([Customers_Addresses:31])
	READ WRITE:C146([Addresses:30])
	READ WRITE:C146([Customers_Contacts:52])
	READ WRITE:C146([Contacts:51])
	READ ONLY:C145([Salesmen:32])  // Modified by: Mel Bohince (1/16/20) 
	READ ONLY:C145([Finished_Goods:26])  // Modified by: Mel Bohince (1/16/20) 
	
	If ([Customers:16]SalesmanID:3="") | (User in group:C338(Current user:C182; "SalesManager"))
		LIST TO ARRAY:C288("SalesReps"; aSalesReps)  //11/18/94
	Else 
		Core_ObjectSetColor(->[Customers:16]SalesmanID:3; -11)
	End if 
Else 
	OBJECT SET ENABLED:C1123(bAcceptRec; False:C215)
	OBJECT SET ENABLED:C1123(bColor; False:C215)
	OBJECT SET ENABLED:C1123(bLinkRel1; False:C215)
	OBJECT SET ENABLED:C1123(bLinkRel2; False:C215)
End if 

If (Is new record:C668([Customers:16]))
	[Customers:16]ID:1:=app_set_id_as_string(Table:C252(->[Customers:16]))
	[Customers:16]SalesAnalystID:8:="n/a"  // we love ya bob 
	[Customers:16]CreditLimit:12:=0  //UPR 1173 BAK
	[Customers:16]Std_Terms:13:="1/3, 1/3, 1/3"  //UPR 1173 BAK
	[Customers:16]zCount:36:=1
	[Customers:16]NeedArtApproval:60:=True:C214
	[Customers:16]NeedSizeAndStyle:58:=True:C214
	[Customers:16]NeedColorApproval:59:=True:C214
	[Customers:16]NeedSpecSheet:51:=True:C214
	[Customers:16]Pays_Overship:42:=True:C214  // Modified by: Mel Bohince (6/4/15) 
	[Customers:16]Std_Incoterms:11:="EXW ROANOKE VA"  // Modified by: Mel Bohince (11/26/19) 
	GOTO OBJECT:C206([Customers:16]Name:2)
Else 
	GOTO OBJECT:C206([Customers:16]Notes:16)
End if 

If (User in group:C338(Current user:C182; "RolePlanner"))
	SetObjectProperties("RolePlanner@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
Else 
	SetObjectProperties("RolePlanner@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
End if 

If (User in group:C338(Current user:C182; "RoleAccounting"))
	SetObjectProperties("RoleAccounting@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/6/13)
Else 
	SetObjectProperties("RoleAccounting@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
End if 

If (User in group:C338(Current user:C182; "SalesManager"))
	OBJECT SET ENABLED:C1123(bTeam; True:C214)
	OBJECT SET ENABLED:C1123(bEmail; True:C214)
End if 