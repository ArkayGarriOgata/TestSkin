// ----------------------------------------------------
// Object Method: [zz_control].SelectIssueLog.Variable5
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

If (Self:C308->=1)
	SetObjectProperties(""; ->sJobForm; True:C214; ""; False:C215)
	SetObjectProperties(""; ->dDateBegin; True:C214; ""; True:C214)
	SetObjectProperties(""; ->dDateEnd; True:C214; ""; True:C214)
	sJobForm:=""
	ddateBegin:=!00-00-00!
	dDateEnd:=4D_Current_date
	GOTO OBJECT:C206(dDateBegin)
End if 