// ----------------------------------------------------
// Form Method: [zz_control].Copy_D
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	If (fAutoID)
		SetObjectProperties(""; ->sCriterion2; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
		SetObjectProperties("newId@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
	Else 
		SetObjectProperties(""; ->sCriterion2; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/14/13)
		SetObjectProperties("newId@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/14/13)
	End if 
End if 