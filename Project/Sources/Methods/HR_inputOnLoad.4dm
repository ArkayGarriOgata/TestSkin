//%attributes = {}
// ----------------------------------------------------
// Date and time: 10/27/05, 14:42:44
// ----------------------------------------------------
// Method: HR_inputOnLoad
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

C_LONGINT:C283(iTabControl)

uiState:=""
fCanChange:=True:C214
fAskedOnce:=False:C215

HR_setDisplayName

If (Is new record:C668([Users:5]))
	[Users:5]CreditCard:35:="none"
	[Users:5]CellPhone:34:="none"
	[Users:5]zCount:10:=1
	[Users:5]DOH:29:=4D_Current_date
	If (User in group:C338(Current user:C182; "Roanoke"))
		[Users:5]Location:38:="Roanoke"
	Else 
		[Users:5]Location:38:="Hauppauge"
	End if 
	[Users:5]PhoneExtension:37:="n/a"
	[Users:5]TelePIN:33:="n/a"
	[Users:5]StatusChange:43:=1
End if 

If (Length:C16([Users:5]WorksInDept:15)>4)  //• 7/29/97 cs
	cbMultiple:=1  //• 7/29/97 cs
Else 
	cbMultiple:=0
End if 

ARRAY TEXT:C222(aDepartment; 0)
LIST TO ARRAY:C288("Departments"; aDepartment)  //• 7/29/97 cs populate department popup 
ARRAY TEXT:C222(aDeprtment; Size of array:C274(aDepartment)+1)
INSERT IN ARRAY:C227(aDepartment; 1)
aDepartment{1}:=" All - Accesses All Depts"

OBJECT SET FONT:C164([Users:5]PIN:16; "%Password")
OBJECT SET FONT:C164([Users:5]TelePIN:33; "%Password")

OBJECT SET ENABLED:C1123(bAdd; True:C214)
OBJECT SET ENABLED:C1123(bRequest; True:C214)
OBJECT SET ENABLED:C1123(bApprove; False:C215)
//OBJECT SET ENABLED(bDelete;False)
t3:=HR_getCurrentStatus

Case of 
	: ([Users:5]StatusChange:43=0)  //steady state
		uiState:="CURRENT"
		OBJECT SET ENABLED:C1123(bChangeStatus; False:C215)
		
		If (Length:C16([Users:5]ProposedChange:46)=0)  //set up the template
			[Users:5]ProposedChange:46:=HR_setProposedChange
		Else 
			HR_setProposedChange(9)
		End if 
		
	: ([Users:5]StatusChange:43=1)  //new hire
		uiState:="NEW"
		t3:=":::::::: CURRENT STATUS ::::::::"+Char:C90(13)+"Applicant"
		[Users:5]ProposedChange:46:=HR_setProposedChange
		[Users:5]ProposedChange:46:=":::::::: PROPOSED STATUS ::::::::"+Char:C90(13)+"New Hire"
		
	: ([Users:5]StatusChange:43=2)  //chg proposed, approved?
		uiState:="CHG PENDING"
		SetObjectProperties(""; ->bRequest; True:C214; "Cancel Proposed Change")
		BEEP:C151
		FORM GOTO PAGE:C247(3)
		OBJECT SET ENABLED:C1123(bChangeStatus; False:C215)
		OBJECT SET ENABLED:C1123(bAdd; False:C215)
		SET WINDOW TITLE:C213("Status Change Requires Approval")
		
		If (Position:C15(<>zResp; [Users:5]NeedApprovalFrom:44)>0)
			OBJECT SET ENABLED:C1123(bApprove; True:C214)
		End if 
		
	: ([Users:5]StatusChange:43=3)  //has it been approved?
		uiState:="CHG APPROVED"
		SetObjectProperties(""; ->bRequest; True:C214; "Cancel Proposed Change")
		BEEP:C151
		FORM GOTO PAGE:C247(3)
		OBJECT SET ENABLED:C1123(bAdd; False:C215)
		OBJECT SET ENABLED:C1123(bApprove; False:C215)
		OBJECT SET ENABLED:C1123(bChangeStatus; True:C214)
		SET WINDOW TITLE:C213("Status Change Has Been Approved")
		
		OBJECT SET ENABLED:C1123(bChangeStatus; True:C214)
End case 