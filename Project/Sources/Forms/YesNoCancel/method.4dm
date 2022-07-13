// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/05/12, 14:11:10
// ----------------------------------------------------
// Form Method: YesNoCancel
// Description:
// Form method for the YesNoCancel Dialog
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	SetObjectProperties(""; ->bYes; True:C214; tYes)
	SetObjectProperties(""; ->bNo; True:C214; tNo)
End if 