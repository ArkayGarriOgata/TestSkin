//(s) bApprovePO
//• 5/30/97 cs created
If (User in group:C338(Current user:C182; "PO_Approval")) | (User in group:C338(Current user:C182; "PO_Approval_Mgr"))
	uSpawnProcess("POApproval"; 0; "Approve POs"; True:C214; False:C215)  //091195
	If (False:C215)
		PoApproval
	End if 
Else 
	uNotAuthorized
End if 
//