// ----------------------------------------------------
// Object Method: [Estimates_Carton_Specs].Input.Field27
// ----------------------------------------------------

If ([Estimates_Carton_Specs:19]OriginalOrRepeat:9="Original")
	uConfirm("Is this a customer revision or up-tick?"; "Yes"; "Nothing Obsolete")
	If (ok=1)
		SetObjectProperties(""; ->[Estimates_Carton_Specs:19]ObsoleteCPN:63; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/10/13)
		GOTO OBJECT:C206([Estimates_Carton_Specs:19]ObsoleteCPN:63)
	Else 
		SetObjectProperties(""; ->[Estimates_Carton_Specs:19]ObsoleteCPN:63; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/10/13)
	End if 
	
Else 
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]ObsoleteCPN:63; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/10/13)
End if 