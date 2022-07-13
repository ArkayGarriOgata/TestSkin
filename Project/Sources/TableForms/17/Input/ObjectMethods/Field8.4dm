// ----------------------------------------------------
// Object Method: [Estimates].Input.Field8
// ----------------------------------------------------

If ([Estimates:17]JobNo:50=0)
	uConfirm("You must now click Create Job' to make a budget."; "OK"; "Help")
	SetObjectProperties(""; ->bReviseJob; True:C214; "Create Job")  // Modified by: Mark Zinke (5/10/13)
	OBJECT SET ENABLED:C1123(bReviseJob; True:C214)
	
Else 
	READ ONLY:C145([Jobs:15])
	QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=[Estimates:17]JobNo:50)
	If (Records in selection:C76([Jobs:15])=1)
		uConfirm("You must now click 'Revise Job' to make this effective."; "OK"; "Help")
		SetObjectProperties(""; ->bReviseJob; True:C214; "Revise Job")  // Modified by: Mark Zinke (5/10/13)
		OBJECT SET ENABLED:C1123(bReviseJob; True:C214)
		
	Else 
		uConfirm("Job "+String:C10([Estimates:17]JobNo:50)+" was not found."; "Try Again"; "Cancel")
		[Estimates:17]JobNo:50:=Old:C35([Estimates:17]JobNo:50)
		If (ok=1)
			GOTO OBJECT:C206([Estimates:17]JobNo:50)
		Else 
			SetObjectProperties(""; ->[Estimates:17]JobNo:50; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/10/13)
		End if 
		
	End if 
	REDUCE SELECTION:C351([Jobs:15]; 0)
End if 