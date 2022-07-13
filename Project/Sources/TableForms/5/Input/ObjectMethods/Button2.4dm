If (Position:C15(<>zResp; [Users:5]NeedApprovalFrom:44)>0)
	[Users:5]NeedApprovalFrom:44:=Replace string:C233([Users:5]NeedApprovalFrom:44; <>zResp; "")
	[Users:5]ApprovedBy:45:=[Users:5]ApprovedBy:45+" "+<>zResp
Else 
	If (Position:C15(<>zResp; [Users:5]ApprovedBy:45)>0)
		BEEP:C151
		ALERT:C41("Thanks again!")
	Else 
		BEEP:C151
		ALERT:C41("Your approval is not required.")
	End if 
End if 