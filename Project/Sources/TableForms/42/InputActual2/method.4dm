//(LP) [JobForm]'InputActual
//12/6/94

Case of 
	: (Form event code:C388=On Load:K2:1)
		BeforeModActual
		
	: (Form event code:C388=On Validate:K2:3)
		[Job_Forms:42]ModDate:7:=4D_Current_date
		[Job_Forms:42]ModWho:8:=<>zResp
		
	: (Form event code:C388=On Unload:K2:2)
		wWindowTitle("pop")
		CLEAR NAMED SELECTION:C333("Jobits")
		
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 
//EOLP