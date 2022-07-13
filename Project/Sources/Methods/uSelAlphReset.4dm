//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: uSelAlphReset
// Description:
// Reset dialog selection variables for alphanumerics
// ----------------------------------------------------

sSlctType:="A"

OBJECT SET LIST BY NAME:C237(sCriterion1; "")
OBJECT SET LIST BY NAME:C237(sCriterion2; "")
OBJECT SET LIST BY NAME:C237(sCriterion3; "")
OBJECT SET FILTER:C235(sCriterion1; "&"+<>sDQ+" -~"+<>sDQ)
OBJECT SET FILTER:C235(sCriterion2; "&"+<>sDQ+" -~"+<>sDQ)
OBJECT SET FILTER:C235(sCriterion3; "&"+<>sDQ+" -~"+<>sDQ)
OBJECT SET FORMAT:C236(sCriterion1; "")
OBJECT SET FORMAT:C236(sCriterion2; "")
OBJECT SET FORMAT:C236(sCriterion3; "")
SetObjectProperties(""; ->sCriterion2; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
SetObjectProperties(""; ->sCriterion3; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)