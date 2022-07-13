// ----------------------------------------------------
// Form Method: [zz_control].Request
// Sript initializer [preferences]request
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	If (sOkText#"")
		SetObjectProperties(""; ->baAccept; True:C214; sOKText)
	End if 
	If (sCancelText#"")
		SetObjectProperties(""; ->bcCancel; True:C214; sCancelText)
	End if 
	HIGHLIGHT TEXT:C210(xText; 1; Length:C16(xText)+1)  //•6/19/97 cs added to make it easier to respond
End if 