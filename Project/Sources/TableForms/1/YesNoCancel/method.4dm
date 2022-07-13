// ----------------------------------------------------
// Form Method: [zz_control].YesNoCancel
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (sOKText#"")
			SetObjectProperties(""; ->bAccept; True:C214; sOKText)
		End if 
		If (sNoText#"")
			SetObjectProperties(""; ->bNo; True:C214; sNoText)
		End if 
		If (sCancelText#"")
			SetObjectProperties(""; ->bCancel; True:C214; sCancelText)
		End if 
End case 