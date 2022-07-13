// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 4/23/03  09:03
// ----------------------------------------------------
// Object Method: [Purchase_Orders_Items].OpenItemsDialog.Check Box2
// ----------------------------------------------------

If (cb2=1)
	dDateBegin:=!00-00-00!
	dDateEnd:=4D_Current_date-1
	SetObjectProperties(""; ->dDateBegin; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
	SetObjectProperties(""; ->dDateEnd; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
	OBJECT SET ENABLED:C1123(b_dummy; False:C215)
Else 
	dDateBegin:=Add to date:C393(4D_Current_date; 0; -1; 0)
	dDateEnd:=Add to date:C393(4D_Current_date; 0; 2; 0)
	SetObjectProperties(""; ->dDateBegin; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
	SetObjectProperties(""; ->dDateEnd; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
	OBJECT SET ENABLED:C1123(b_dummy; True:C214)
End if 