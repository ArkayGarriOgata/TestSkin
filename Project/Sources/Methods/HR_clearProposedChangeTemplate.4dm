//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/21/05, 14:57:31
// ----------------------------------------------------
// Method: HR_clearProposedChangeTemplate
// Description
// get rid of <n>
// ----------------------------------------------------

If (Position:C15("<"; [Users:5]ProposedChange:46)>0)
	For ($i; 1; 10)
		[Users:5]ProposedChange:46:=Replace string:C233([Users:5]ProposedChange:46; "<"+String:C10($i)+">"; "")
	End for 
End if 