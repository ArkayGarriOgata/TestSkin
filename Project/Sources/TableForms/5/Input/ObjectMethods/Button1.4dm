// ----------------------------------------------------
// Object Method: [Users].Input.Button1
// ----------------------------------------------------

C_TEXT:C284($r)
C_LONGINT:C283($i)
C_TEXT:C284($another)

$r:=Char:C90(13)

If ([Users:5]StatusChange:43=2)
	LIST TO ARRAY:C288("hr_StatusChgApprovers"; $aInitials)
	[Users:5]NeedApprovalFrom:44:=""
	[Users:5]ApprovedBy:45:=""
	//t3:=HR_getCurrentStatus 
	
	For ($i; 1; Size of array:C274($aInitials))
		CONFIRM:C162("Approval required from "+$aInitials{$i}+"?"; "Yes"; "No")
		If (ok=1)
			[Users:5]NeedApprovalFrom:44:=[Users:5]NeedApprovalFrom:44+" "+$aInitials{$i}+" "
		End if 
	End for 
	
	$another:=""
	Repeat 
		$another:=Request:C163("Any other approvals?"; "enter their initials"; "Include"; "No More")
		If (ok=1)
			If (Length:C16($another)>0) & (Length:C16($another)<5)
				[Users:5]NeedApprovalFrom:44:=[Users:5]NeedApprovalFrom:44+" "+$another+" "
			End if 
		End if 
	Until (ok=0)
	
	If (Length:C16([Users:5]NeedApprovalFrom:44)>0)
		
		SetObjectProperties(""; ->[Users:5]NeedApprovalFrom:44; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
		SetObjectProperties(""; ->[Users:5]StatusChange:43; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
		SetObjectProperties(""; ->[Users:5]ProposedChange:46; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
	End if 
	SetObjectProperties(""; ->bRequest; True:C214; "Cancel Proposed Change")  // Modified by: Mark Zinke (5/14/13)
	
Else 
	SetObjectProperties(""; ->bRequest; True:C214; "Lock Changes and Request Approval")  // Modified by: Mark Zinke (5/14/13)
	[Users:5]StatusChange:43:=0
	[Users:5]NeedApprovalFrom:44:=""
	[Users:5]ApprovedBy:45:=""
	[Users:5]ProposedChange:46:=HR_setProposedChange
	SetObjectProperties(""; ->[Users:5]ProposedChange:46; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/14/13)
End if 