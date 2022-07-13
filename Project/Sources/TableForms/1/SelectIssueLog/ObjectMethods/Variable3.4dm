// ----------------------------------------------------
// Object Method: [zz_control].SelectIssueLog.Variable3
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

If (Self:C308->=1)
	SetObjectProperties(""; ->xCol1; True:C214; ""; True:C214)
	GOTO OBJECT:C206(xCol1)
Else 
	SetObjectProperties(""; ->xCol1; True:C214; ""; False:C215)
	xCol1:=""
	GOTO OBJECT:C206(dDateBegin)
End if 