// ----------------------------------------------------
// Form Method: [zz_control].SelectIssueLog
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		SetObjectProperties(""; ->xCol1; True:C214; ""; False:C215)
		SetObjectProperties(""; ->sJobForm; True:C214; ""; False:C215)
		SetObjectProperties(""; ->dDateBegin; True:C214; ""; True:C214)
		SetObjectProperties(""; ->dDateEnd; True:C214; ""; True:C214)
		sJobForm:=""
		rbDate:=1
End case 