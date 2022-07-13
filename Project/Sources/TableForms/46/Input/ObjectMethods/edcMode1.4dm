[Customers_ReleaseSchedules:46]Mode:56:=util_ComboBoxAction(->aMode; aMode{0})

If (Position:C15("AIR"; [Customers_ReleaseSchedules:46]Mode:56)>0)
	[Customers_ReleaseSchedules:46]Air_Shipment:51:=True:C214
Else 
	[Customers_ReleaseSchedules:46]Air_Shipment:51:=False:C215
End if 