app_basic_list_form_method

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (User in group:C338(Current user:C182; "Req_Approval")) & (iMode=2)
			OBJECT SET ENABLED:C1123(bApprove; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bApprove; False:C215)
		End if 
		
End case 