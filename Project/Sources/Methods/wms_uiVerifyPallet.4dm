//%attributes = {}
// Method: wms_uiVerifyPallet () -> 
// ----------------------------------------------------
// by: mel: 12/17/04, 00:09:58
// ----------------------------------------------------
// Description:
// 
// Updates:

// ----------------------------------------------------
C_TEXT:C284($1)
If (False:C215)
	
	If (Count parameters:C259=0)
		$pid:=New process:C317("wms_verifyPalletContents"; <>lMinMemPart; "Verify Pallet"; "init")
		wms_verifyPalletContents
		
	Else 
		$winRef:=Open form window:C675([WMS_Compositions:124]; "verifyPalletLoad")
		DIALOG:C40([WMS_Compositions:124]; "verifyPalletLoad")
		CLOSE WINDOW:C154($winRef)
	End if 
	
	
End if 
BEEP:C151