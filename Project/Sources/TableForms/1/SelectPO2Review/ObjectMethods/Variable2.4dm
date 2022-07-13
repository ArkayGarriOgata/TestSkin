// ----------------------------------------------------
// Object Method: [zz_control].SelectPO2Review.Variable2
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

SetObjectProperties(""; ->sCriterion1; True:C214; ""; True:C214)
SetObjectProperties(""; ->dDate; True:C214; ""; False:C215)
dDate:=!00-00-00!
GOTO OBJECT:C206(sCriterion1)