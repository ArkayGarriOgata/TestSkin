// ----------------------------------------------------
// Object Method: [Estimates_Carton_Specs].Input.Field28
// ----------------------------------------------------

If ([Estimates_Carton_Specs:19]StripHoles:46)
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowMatl:35; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/10/13)
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowGauge:36; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/10/13)
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowWth:37; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/10/13)
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowHth:38; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/10/13)
	GOTO OBJECT:C206([Estimates_Carton_Specs:19]WindowMatl:35)
Else 
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowMatl:35; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/10/13)
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowGauge:36; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/10/13)
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowWth:37; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/10/13)
	SetObjectProperties(""; ->[Estimates_Carton_Specs:19]WindowHth:38; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/10/13)
End if 