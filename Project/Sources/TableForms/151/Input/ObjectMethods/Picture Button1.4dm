// ----------------------------------------------------
// Object Method: [Tool_Drawers].Input.Picture Button1
// ----------------------------------------------------

$pwd:=Request:C163("Enter your pin:"; ""; "Unlock"; "Cancel")
If (ok=1)
	If ($pwd=("jj"+[Tool_Drawers:151]Bin:1))
		SetObjectProperties(""; ->block; False:C215)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->block2; True:C214)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties("entry@"; -><>NULL; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		GOTO OBJECT:C206([Tool_Drawers:151]Contents:2)
	Else 
		BEEP:C151
	End if 
End if 