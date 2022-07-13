app_form_button("first")

If (Form:C1466.position>0)
	If (Form:C1466.editEntity.Air_Shipment) & (Length:C16(Form:C1466.editEntity.Mode)=0)
		Form:C1466.editEntity.Mode:="AIR"
	End if 
	util_ComboBoxSetup(->aMode; Form:C1466.editEntity.Mode)
	Text23:=fGetAddressText(Form:C1466.editEntity.Billto)
	Text25:=fGetAddressText(Form:C1466.editEntity.Shipto)
	t9:=THC_decode(Form:C1466.editEntity.THC_State)
End if 

