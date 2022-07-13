// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.PickBillTo   ( ) ->
// By: Mel Bohince @ 06/12/20, 08:42:58
// Description
// 
// ----------------------------------------------------


$addressID:=REL_SelectAddress(Form:C1466.editEntity.CustID; "Ship to"; Form:C1466.editEntity.Shipto)

If ($addressID#Form:C1466.editEntity.Shipto)  //it was changed
	Form:C1466.editEntity.Shipto:=$addressID
	Text25:=fGetAddressText($addressID)
	OBJECT SET ENABLED:C1123(*; "memberValidate1"; True:C214)
End if 