
Case of 
	: (Form event code:C388=On Load:K2:1)
		BeforePSpec
		
	: (Form event code:C388=On Validate:K2:3)
		[Process_Specs:18]ModDate:102:=4D_Current_date
		[Process_Specs:18]ModWho:103:=<>zResp
		CLEAR NAMED SELECTION:C333("Related")
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		
	: (Form event code:C388=On Unload:K2:2)
		wWindowTitle("pop")
End case 
//