// ----------------------------------------------------
// Form Method: [Finished_Goods].PickMultiFG
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		SetObjectProperties(""; ->Header1; True:C214; "x")
		SetObjectProperties(""; ->Header2; True:C214; "Product Code")
		SetObjectProperties(""; ->Header3; True:C214; "Description")
		SetObjectProperties(""; ->Header5; True:C214; "Week")
		SetObjectProperties(""; ->Header6; True:C214; "Stock")
		SetObjectProperties(""; ->Header7; True:C214; "Outline")
		SetObjectProperties(""; ->Header8; True:C214; "Process Spec")
		OBJECT SET ENABLED:C1123(bOK; False:C215)
		If (allowNew)
			OBJECT SET ENABLED:C1123(bNew; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bNew; False:C215)
		End if 
End case 