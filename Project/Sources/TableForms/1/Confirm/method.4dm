//(LP) comfirm
Case of 
	: (Form event code:C388=On Load:K2:1)
		If (sOKText#"")
			SetObjectProperties(""; ->baOK; True:C214; sOKText)
		End if 
		If (sCancelText#"")
			SetObjectProperties(""; ->bcCancel; True:C214; sCancelText)
		End if 
End case 