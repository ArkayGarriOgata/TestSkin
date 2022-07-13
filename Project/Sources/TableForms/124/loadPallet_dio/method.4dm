//FM: loadPallet_dio() -> 
//@author Mel - 5/9/03  16:59

Case of 
	: (Form event code:C388=On Data Change:K2:15)
		wmss_stateMachine
		
	: (Form event code:C388=On Load:K2:1)
		wmss_init
		SetObjectProperties(""; ->rft_error_log; False:C215)
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 
