//%attributes = {}
// Method: HR_inputOnDataChange
// User name (OS): work
// Date and time: 10/27/05, 14:44:56
// ----------------------------------------------------

C_BOOLEAN:C305($ask)

$ask:=False:C215

If (Old:C35([Users:5]BusTitle:5)#[Users:5]BusTitle:5)
	$ask:=True:C214
	[Users:5]ProposedChange:46:=HR_setProposedChange(1; [Users:5]BusTitle:5)
Else 
	[Users:5]ProposedChange:46:=HR_setProposedChange(1; "")
End if 

If (Old:C35([Users:5]Dept:31)#[Users:5]Dept:31)
	$ask:=True:C214
	[Users:5]ProposedChange:46:=HR_setProposedChange(2; [Users:5]Dept:31)
Else 
	[Users:5]ProposedChange:46:=HR_setProposedChange(2; "")
End if 

If (Old:C35([Users:5]Classification:49)#[Users:5]Classification:49)
	$ask:=True:C214
	[Users:5]ProposedChange:46:=HR_setProposedChange(3; [Users:5]Classification:49)
Else 
	[Users:5]ProposedChange:46:=HR_setProposedChange(3; "")
End if 

If (Old:C35([Users:5]Grade:51)#[Users:5]Grade:51)
	$ask:=True:C214
	[Users:5]ProposedChange:46:=HR_setProposedChange(4; [Users:5]Grade:51)
Else 
	[Users:5]ProposedChange:46:=HR_setProposedChange(4; "")
End if 

If (Old:C35([Users:5]Shift:52)#[Users:5]Shift:52)
	$ask:=True:C214
	[Users:5]ProposedChange:46:=HR_setProposedChange(5; [Users:5]Shift:52)
Else 
	[Users:5]ProposedChange:46:=HR_setProposedChange(5; "")
End if 

If (Old:C35([Users:5]HrPerWeek:50)#[Users:5]HrPerWeek:50)
	$ask:=True:C214
	[Users:5]ProposedChange:46:=HR_setProposedChange(6; String:C10([Users:5]HrPerWeek:50))
Else 
	[Users:5]ProposedChange:46:=HR_setProposedChange(6; "")
End if 

If (Old:C35([Users:5]Salary:53)#[Users:5]Salary:53)
	$ask:=True:C214
	[Users:5]ProposedChange:46:=HR_setProposedChange(7; String:C10([Users:5]Salary:53; "^,^^^,^^0.00")+"/"+[Users:5]SalaryUnit:54)
Else 
	[Users:5]ProposedChange:46:=HR_setProposedChange(7; "")
End if 

If (Old:C35([Users:5]SalaryUnit:54)#[Users:5]SalaryUnit:54)
	$ask:=True:C214
	[Users:5]ProposedChange:46:=HR_setProposedChange(7; String:C10([Users:5]Salary:53; "^,^^^,^^0.00")+"/"+[Users:5]SalaryUnit:54)
Else 
	[Users:5]ProposedChange:46:=HR_setProposedChange(7; "")
End if 

If (Old:C35([Users:5]ReasonForChange:55)#[Users:5]ReasonForChange:55)
	$ask:=True:C214
	[Users:5]ProposedChange:46:=HR_setProposedChange(8; [Users:5]ReasonForChange:55)
Else 
	[Users:5]ProposedChange:46:=HR_setProposedChange(8; "")
End if 

If (Old:C35([Users:5]NatureOfChange:48)#[Users:5]NatureOfChange:48)
	$ask:=True:C214
	[Users:5]ProposedChange:46:=HR_setProposedChange(9; [Users:5]NatureOfChange:48)
Else 
	[Users:5]ProposedChange:46:=HR_setProposedChange(9; "")
End if 

If (fCanChange) & (Not:C34(fAskedOnce))
	If ($ask)
		fAskedOnce:=True:C214
		uConfirm("Are you initiating a Change of Status?"; "Yes"; "No")
		If (OK=1)
			[Users:5]StatusChange:43:=2
			fCanChange:=False:C215
		End if 
	End if 
End if 