
Case of 
	: (Form event code:C388=On Load:K2:1)
		vCommand:=""
		If (Size of array:C274(<>acommand)=0)
			OBJECT SET ENABLED:C1123(<>ib_delvr_schd; False:C215)
		Else 
			OBJECT SET ENABLED:C1123(<>ib_delvr_schd; True:C214)
		End if 
		
End case 