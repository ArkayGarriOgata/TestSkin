//(s) rREal1 (subtotal fields for PiRMCountsheet Report
Self:C308->:=Subtotal:C97([Raw_Materials_Locations:25]QtyOH:9)
If (vDoc#?00:00:00?)
	SEND PACKET:C103(vdoc; "Subtotal for Material: "+String:C10(Self:C308->)+Char:C90(13))
End if 