// ----------------------------------------------------
// Object Method: [zz_control].SelectPO2Review.Variable6
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

SetObjectProperties(""; ->sCriterion1; True:C214; ""; False:C215)
SetObjectProperties(""; ->dDate; True:C214; ""; False:C215)
sCriterion1:=""
dDate:=!00-00-00!
POST KEY:C465(9)  //move out of any field
POST KEY:C465(Character code:C91("f"); 256)  //search