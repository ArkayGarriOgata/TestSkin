Case of 
	: (Form event code:C388=On Load:K2:1)
		wWindowTitle("push"; "Cost Center "+[Cost_Centers:27]ID:1)
		fCCMaint:=True:C214
		If (iMode#2)
			OBJECT SET ENABLED:C1123(bDelete; False:C215)
		End if 
		If (iMode=3)
			OBJECT SET ENABLED:C1123(bValidate; False:C215)
		End if 
		
		$msg:=util_formName(Current form table:C627)+" "+util_readOnlyState(Current form table:C627)
		utl_LogfileServer(<>zResp; $msg)
		
		//app_Log_Usage ("log";util_formName (Current form table);util_readOnlyState (Current form table))
		
	: (Form event code:C388=On Unload:K2:2)
		fCCMaint:=False:C215
		fCancel:=True:C214
		wWindowTitle("pop")
		
	: (Form event code:C388=On Close Box:K2:21)
		bDone:=1
		CANCEL:C270
		
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[Cost_Centers:27]ModDate:16; ->[Cost_Centers:27]ModWho:17; ->[Cost_Centers:27]zCount:15)
End case 
//