//%attributes = {"publishedWeb":true}
//(p) SetReturnReject
//UPR 1292   chip 11/4/94.
//$1 optional; pointer to script field

SetObjectProperties("Reason@"; -><>NULL; True:C214)  // Added by: Mark Zinke (5/9/13)
SetObjectProperties(""; ->sCriterion7; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)
SetObjectProperties(""; ->sCriterion9; True:C214; ""; True:C214)  // Added by: Mark Zinke (5/9/13)

Case of 
	: (sCriterion9="Return")
		OBJECT SET LIST BY NAME:C237(sCriterion7; "ReturnReason")
		
	: (sCriterion9="Reject")
		OBJECT SET LIST BY NAME:C237(sCriterion7; "RejectReason")
		
	Else 
		OBJECT SET LIST BY NAME:C237(sCriterion7; "")
		SetObjectProperties("Reason@"; -><>NULL; False:C215)  // Added by: Mark Zinke (5/9/13)
		SetObjectProperties(""; ->sCriterion7; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
		SetObjectProperties(""; ->sCriterion9; True:C214; ""; False:C215)  // Added by: Mark Zinke (5/9/13)
End case 

If (Count parameters:C259=1)  //if this is called from a script goto area
	GOTO OBJECT:C206(sCriterion7)
End if 