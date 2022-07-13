// ----------------------------------------------------
// User name (OS): mlb
// Date and time: 11/21/02  15:13
// ----------------------------------------------------
// Object Method: [zz_control].MachTicket.Variable18
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

If (rMAMRHours#0)
	SetObjectProperties(""; ->tMRcode; True:C214; ""; True:C214)
	SetObjectProperties("mr@"; -><>NULL; True:C214; ""; True:C214)
	//GOTO OBJECT(tMRcode)  // Modified by: Mark Zinke (11/21/13) 
Else 
	SetObjectProperties(""; ->tMRcode; True:C214; ""; False:C215)
	SetObjectProperties("mr@"; -><>NULL; True:C214; ""; False:C215)
End if 