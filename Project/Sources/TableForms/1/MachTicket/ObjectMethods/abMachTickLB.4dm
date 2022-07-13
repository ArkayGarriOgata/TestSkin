// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/01/13, 12:05:34
// ----------------------------------------------------
// Object Method: [zz_control].MachTicket.abMachTickLB
// ----------------------------------------------------

If (Size of array:C274(adMADate)>0)
	OBJECT SET ENABLED:C1123(bOK; True:C214)
	OBJECT SET ENABLED:C1123(bOKStay; True:C214)
Else 
	OBJECT SET ENABLED:C1123(bOK; False:C215)
	OBJECT SET ENABLED:C1123(bOKStay; False:C215)
End if 

If ((Form event code:C388=On Clicked:K2:4) & (Find in array:C230(abMachTickLB; True:C214)>0))
	OBJECT SET ENABLED:C1123(bDelete; True:C214)
Else 
	OBJECT SET ENABLED:C1123(bDelete; False:C215)
End if 