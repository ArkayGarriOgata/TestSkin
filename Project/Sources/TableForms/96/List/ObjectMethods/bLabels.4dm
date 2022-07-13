uConfirm("Print labels for the "+String:C10(Records in selection:C76([WMS_SerializedShippingLabels:96]))+" displayed records?"; "Print"; "Cancel")
If (ok=1)
	$printerName:=Get current printer:C788
	$numLabels:=2
	$numLabels:=Num:C11(Request:C163("Enter number of labels per container:"; String:C10($numLabels)))
	
	ARRAY TEXT:C222(<>aPrinterNames; 0)
	PRINTERS LIST:C789(<>aPrinterNames)
	wWindowTitle("push"; "Pick the Dymo Printer")
	$winRef:=OpenSheetWindow(->[zz_control:1]; "SelectPrinter_dio")
	DIALOG:C40([zz_control:1]; "SelectPrinter_dio")
	CLOSE WINDOW:C154($winRef)
	wWindowTitle("pop")
	If (ok=1)
		$printerNamePref:=<>aPrinterNames{0}
	End if 
	
	If ($numLabels>0)
		util_PAGE_SETUP(->[WMS_SerializedShippingLabels:96]; "Spec2005")
		
		SET PRINT OPTION:C733(Number of copies option:K47:4; $numLabels)
		PRINT SETTINGS:C106
		SET CURRENT PRINTER:C787($printerNamePref)
		
		If (ok=1)
			FIRST RECORD:C50([WMS_SerializedShippingLabels:96])
			
			C_LONGINT:C283($i; $numRecs)
			C_BOOLEAN:C305($break)
			$break:=False:C215
			$numRecs:=Records in selection:C76([WMS_SerializedShippingLabels:96])
			
			uThermoInit($numRecs; "Updating Records")
			For ($i; 1; $numRecs)
				If ($break)
					$i:=$i+$numRecs
				End if 
				If (Position:C15("Procter"; [WMS_SerializedShippingLabels:96]Customer:24)>0)
					$labelFormat:="Spec2005"
				Else 
					$labelFormat:="SSCC_Arkay"
				End if 
				If ([WMS_SerializedShippingLabels:96]ContainerType:13="SKID")
					If ([Finished_Goods:26]ProductCode:1#[WMS_SerializedShippingLabels:96]CPN:2)
						READ ONLY:C145([Finished_Goods:26])
						$numFound:=qryFinishedGood("#CPN"; [WMS_SerializedShippingLabels:96]CPN:2)
					End if 
					Print form:C5([WMS_SerializedShippingLabels:96]; $labelFormat)
				Else 
					Print form:C5([WMS_SerializedShippingLabels:96]; "GayLordLabel")
				End if 
				
				NEXT RECORD:C51([WMS_SerializedShippingLabels:96])
				uThermoUpdate($i)
			End for 
			uThermoClose
			
		End if 
	End if 
	SET CURRENT PRINTER:C787($printerName)
End if 