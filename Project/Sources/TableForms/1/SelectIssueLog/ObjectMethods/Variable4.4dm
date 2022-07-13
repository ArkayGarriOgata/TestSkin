// ----------------------------------------------------
// Object Method: [zz_control].SelectIssueLog.Variable4
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

If (Self:C308->=1)
	SetObjectProperties(""; ->sJobForm; True:C214; ""; True:C214)
	SetObjectProperties(""; ->dDateBegin; True:C214; ""; False:C215)
	SetObjectProperties(""; ->dDateEnd; True:C214; ""; False:C215)
	sJobForm:=""
	ddateBegin:=!00-00-00!
	dDateEnd:=!00-00-00!
	GOTO OBJECT:C206(sJobForm)
End if 