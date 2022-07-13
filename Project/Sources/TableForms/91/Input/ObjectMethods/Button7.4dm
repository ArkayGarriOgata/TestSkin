//(S) [CONTROL]fgEvent'ibMove
CONFIRM:C162("Create a new SSCC labels or update an existing one?"; "New"; "Update")
If (ok=1)
	uSpawnProcess("Barcode_SSCC_PnG"; <>lMinMemPart; "SSCC"; True:C214; False:C215)
	If (False:C215)  //list called procedures for 4D Insider
		Barcode_SSCC_PnG
	End if 
Else 
	ViewSetter(2; ->[WMS_SerializedShippingLabels:96])
End if 
//EOS
