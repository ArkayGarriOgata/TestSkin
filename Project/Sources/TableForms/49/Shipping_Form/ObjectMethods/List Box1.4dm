// ----------------------------------------------------
// Object Method: [Customers_Bills_of_Lading].Shipping_Form.List Box1
// ----------------------------------------------------
BOL_setControls

If (User in group:C338(Current user:C182; "RoleRestrictedAccess"))
	OBJECT SET ENABLED:C1123(bAskMe; False:C215)
End if 