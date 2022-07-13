// ----------------------------------------------------
// Object Method: [zz_control].SelectPO2Review.Variable4
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

SetObjectProperties(""; ->sCriterion1; True:C214; ""; False:C215)
SetObjectProperties(""; ->dDate; True:C214; ""; True:C214)
sCriterion1:=""
dDate:=4D_Current_date
GOTO OBJECT:C206(dDate)