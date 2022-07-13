Case of 
	: (Form event code:C388=On Load:K2:1)
		
		If ([zz_control:1]InvInProgress:24)
			OBJECT SET ENABLED:C1123(<>ibNewPhyInv; False:C215)
			OBJECT SET ENABLED:C1123(<>ibEndPhyInv; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(<>ibEndPhyInv; False:C215)
			OBJECT SET ENABLED:C1123(<>ibNewPhyInv; True:C214)
		End if 
		
		If (Size of array:C274(<>aAPIRptPop)=0)
			//*API
			ARRAY TEXT:C222(<>aAPIRptPop; 2)
			<>aAPIRptPop{1}:="API Trans and Error Rpt"
			<>aAPIRptPop{2}:="API Standard Search Rpt"
		End if 
		
		If (Length:C16([z_administrators:2]MAIL_FROM:24)=0)
			[z_administrators:2]MAIL_FROM:24:="Virtual.Factory@arkay.com"
		End if 
		If (Length:C16([z_administrators:2]MAIL_REPLYTO:25)=0)
			[z_administrators:2]MAIL_REPLYTO:25:="mel.bohince@arkay.com"
		End if 
		
		If (Length:C16([z_administrators:2]POP3_HOST:26)=0)
			[z_administrators:2]POP3_HOST:26:="mail.arkay.com"
		End if 
		If (Length:C16([z_administrators:2]POP3_USERNAME:27)=0)
			[z_administrators:2]POP3_USERNAME:27:="Virtual.Factory"
		End if 
		If (Length:C16([z_administrators:2]POP3_PASSWORD:28)=0)
			[z_administrators:2]POP3_PASSWORD:28:="n9tj9aun"
		End if 
End case 
//eolp