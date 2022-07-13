//(LP)RMEvent
//all access to this pallete gives OK to use all buttons
//UNLESS noted below.
//10/13/94 upr 1203
//upr 1263 10/29/94
//081500 restrick all unless given specific authorization

If (Form event code:C388=On Load:K2:1)
	If (Size of array:C274(<>aRMRptPop)=0)
		arrRMreports
	End if 
	
	OBJECT SET ENABLED:C1123(ibNew; False:C215)
	OBJECT SET ENABLED:C1123(ibMod; False:C215)
	OBJECT SET ENABLED:C1123(ibRev; False:C215)
	OBJECT SET ENABLED:C1123(ibDel; False:C215)
	OBJECT SET ENABLED:C1123(ibCopy; False:C215)
	OBJECT SET ENABLED:C1123(ibRec; False:C215)
	OBJECT SET ENABLED:C1123(ibMove; False:C215)
	OBJECT SET ENABLED:C1123(ibIss; False:C215)
	OBJECT SET ENABLED:C1123(ibRtn; False:C215)
	OBJECT SET ENABLED:C1123(ibAdj; False:C215)
	OBJECT SET ENABLED:C1123(bConver; False:C215)
	OBJECT SET ENABLED:C1123(bConver1; False:C215)
	OBJECT SET ENABLED:C1123(bQuote; False:C215)  //barcode
	OBJECT SET ENABLED:C1123(ibTrade; False:C215)
	OBJECT SET ENABLED:C1123(bMSDS; False:C215)
	OBJECT SET ENABLED:C1123(bFixIssue; False:C215)
	OBJECT SET ENABLED:C1123(bMisngIssue; False:C215)
	OBJECT SET ENABLED:C1123(bInk1; False:C215)
	ARRAY TEXT:C222(<>aPopAlloc; 1)  //12/7/94 need to be able to delete allocations
	<>aPopAlloc{1}:="Access Denied"
	<>aPopAlloc:=0
	
	If (User in group:C338(Current user:C182; "RMcreate"))
		OBJECT SET ENABLED:C1123(ibNew; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "RMupdate"))
		OBJECT SET ENABLED:C1123(ibMod; True:C214)
		OBJECT SET ENABLED:C1123(ibDel; True:C214)
		OBJECT SET ENABLED:C1123(ibCopy; True:C214)
		OBJECT SET ENABLED:C1123(ibTrade; True:C214)
		OBJECT SET ENABLED:C1123(bMSDS; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "RMinquire"))
		OBJECT SET ENABLED:C1123(ibRev; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "RMadjustments"))
		OBJECT SET ENABLED:C1123(ibAdj; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "RMtransfer"))
		OBJECT SET ENABLED:C1123(ibMove; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "RMreceiveRtn"))
		OBJECT SET ENABLED:C1123(ibRec; True:C214)
		OBJECT SET ENABLED:C1123(ibRtn; True:C214)
		OBJECT SET ENABLED:C1123(bQuote; True:C214)  //barcode
	End if 
	
	If (User in group:C338(Current user:C182; "WorkInProcess"))
		OBJECT SET ENABLED:C1123(ibIss; True:C214)
		OBJECT SET ENABLED:C1123(bMisngIssue; True:C214)  //add ink issue
		OBJECT SET ENABLED:C1123(bFixIssue; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "RoleDataEntry"))
		OBJECT SET ENABLED:C1123(ibIss; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "RoleCostAccountant"))
		OBJECT SET ENABLED:C1123(bConver1; True:C214)
		OBJECT SET ENABLED:C1123(bConver; True:C214)
		OBJECT SET ENABLED:C1123(bInk1; True:C214)
	Else 
		OBJECT SET ENABLED:C1123(bConver1; False:C215)
		OBJECT SET ENABLED:C1123(bConver; False:C215)
	End if 
	
	If (<>PHYSICAL_INVENORY_IN_PROGRESS)
		OBJECT SET ENABLED:C1123(ibRec; False:C215)
		OBJECT SET ENABLED:C1123(ibMove; False:C215)
		OBJECT SET ENABLED:C1123(ibIss; False:C215)
		OBJECT SET ENABLED:C1123(ibRtn; False:C215)
		OBJECT SET ENABLED:C1123(ibAdj; False:C215)
		OBJECT SET ENABLED:C1123(bFixIssue; False:C215)
		OBJECT SET ENABLED:C1123(bMisngIssue; False:C215)
	End if 
	
	If (<>bButtons)  // Added by: Mark Zinke (2/8/13)
		FORM GOTO PAGE:C247(2)
		GET WINDOW RECT:C443($xlLeft; $xlTop; $xlRight; $xlBottom)
		SET WINDOW RECT:C444($xlLeft; $xlTop; $xlRight; $xlBottom)
	End if 
End if 