Form:C1466.editEntity.Mode:=util_ComboBoxAction(->aMode; aMode{0})

If (Position:C15("AIR"; Form:C1466.editEntity.Mode)>0)
	Form:C1466.editEntity.Air_Shipment:=True:C214
Else 
	Form:C1466.editEntity.Air_Shipment:=False:C215
End if 