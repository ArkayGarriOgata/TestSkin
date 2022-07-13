//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 07/31/08, 10:47:36
// ----------------------------------------------------
// Method: Pjt_AddToProjectLimitor
// Description
// keep users from doing a mass fuckup
// ----------------------------------------------------

C_BOOLEAN:C305($0)
C_POINTER:C301($1)  //table to check

Case of 
	: (Records in selection:C76($1->)=0)
		uConfirm("No records were found."; "Try Again"; "Cancel")
		$0:=False:C215
		
	: (Current user:C182="Designer")
		$0:=True:C214
		
	: (Records in selection:C76($1->)=1)
		$0:=True:C214
		
	Else 
		uConfirm("You must select only one record to Add to Project. Or log in as Designer"; "Try Again"; "Cancel")
		$0:=False:C215
End case 