//(LP) [ESTIMATE]'Input
//2/23/95 upr 173
//•062295  MLB  UPR 1661
//•062695  MLB  UPR 205
//•090399  mlb  UPR 2052

Case of 
	: (Form event code:C388=On Load:K2:1)
		beforeEstimate
		//app_Log_Usage ("log";util_formName ();util_readOnlyState ())
		
		
	: (Form event code:C388=On Unload:K2:2)
		uCancelEstimate
		wWindowTitle("pop")
		<>FloatingAlert:=""
		POST OUTSIDE CALL:C329(<>FloatingAlert_PID)
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		
	: (Form event code:C388=On Validate:K2:3)
		Estimate_validate
End case 