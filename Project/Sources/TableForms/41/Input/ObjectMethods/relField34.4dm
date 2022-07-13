// ----------------------------------------------------
// User name (OS): MLB
// Date 092595
// ----------------------------------------------------
// Object Method: [Customers_Order_Lines].Input.relField34
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]PayU:31:=Num:C11([Customers_Order_Lines:41]PayUse:47))
If ([Customers_Order_Lines:41]PayUse:47)
	SetObjectProperties(""; ->bPU; True:C214)
Else 
	SetObjectProperties(""; ->bPU; False:C215)
End if 