// ----------------------------------------------------
// Form Method: [Tool_Drawers].Input
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		SetObjectProperties("entry@"; -><>NULL; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->block; True:C214)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->block2; False:C215)  // Modified by: Mark Zinke (5/13/13)
		flocked:=True:C214
		
End case 
