// ----------------------------------------------------
// Object Method: [Estimates].Input.Highlight Button1
// ----------------------------------------------------

If (Form event code:C388=On Clicked:K2:4) | (Form event code:C388=On Double Clicked:K2:5)
	If (iMode<3)
		SetObjectProperties(""; ->[Estimates:17]JobNo:50; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		GOTO OBJECT:C206([Estimates:17]JobNo:50)
	Else 
		BEEP:C151
	End if 
End if 