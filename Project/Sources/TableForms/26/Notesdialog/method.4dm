// ----------------------------------------------------
// Object Method: [Finished_Goods].Notesdialog
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	If (iMode<3)
		SetObjectProperties(""; ->xNotes; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		OBJECT SET ENABLED:C1123(bSearch; True:C214)
	Else 
		SetObjectProperties(""; ->xNotes; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		OBJECT SET ENABLED:C1123(bSearch; False:C215)
	End if 
End if 