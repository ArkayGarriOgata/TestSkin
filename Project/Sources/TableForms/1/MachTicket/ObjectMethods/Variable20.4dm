// ----------------------------------------------------
// Date and time: 1419 2/2/95
// ----------------------------------------------------
// Object Method: [zz_control].MachTicket.Variable20
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

If (rMADTHours#0)
	SetObjectProperties(""; ->sMADTCat; True:C214; ""; True:C214)
	SetObjectProperties("dt@"; -><>NULL; True:C214; ""; True:C214)
Else 
	SetObjectProperties(""; ->sMADTCat; True:C214; ""; False:C215)
	SetObjectProperties("dt@"; -><>NULL; True:C214; ""; False:C215)
End if 