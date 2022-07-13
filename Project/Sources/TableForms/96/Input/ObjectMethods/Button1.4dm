
// ----------------------------------------------------
// Method: [WMS_SerializedShippingLabels].Input.Button1
// Description
// 
//
// ----------------------------------------------------
// Modified by: Mel Bohince (9/21/15) v14 didn't like printer selection shit

//$numLabels:=Num(Request("How many labels do you need?";"4";"Print";"Cancel"))
//$printerName:=Get current printer
//$numLabels:=2
//$numLabels:=Num(Request("Enter number of labels per container:";String($numLabels)))

//  //
//ARRAY TEXT(<>aPrinterNames;0)
//PRINTERS LIST(<>aPrinterNames)
//wWindowTitle ("push";"Pick the Dymo Printer")
//$winRef:=OpenSheetWindow (->[zz_control];"SelectPrinter_dio";"Pick Printer with Avery stock")
//DIALOG([zz_control];"SelectPrinter_dio")
//CLOSE WINDOW($winRef)
//wWindowTitle ("pop")
//If (ok=1)
//$printerNamePref:=<>aPrinterNames{0}
//End if 

$sscc:=Insert string:C231([WMS_SerializedShippingLabels:96]HumanReadable:5; " "; 20)
$sscc:=Insert string:C231($sscc; " "; 11)
$sscc:=Insert string:C231($sscc; " "; 4)
$sscc:=Insert string:C231($sscc; ") "; 3)
$sscc:=Insert string:C231($sscc; "("; 1)
$winTitle:="SSCC: "+$sscc
//wWindowTitle ("push";$winTitle)
zwStatusMsg("PRINTING"; "SSCC = "+$sscc)  //+" to "+$printerName)

If (Position:C15("Procter"; [WMS_SerializedShippingLabels:96]Customer:24)>0)
	$labelFormat:="Spec2005"
Else 
	uConfirm("Arkay or PFS style?"; "Arkay"; "PFS")
	If (ok=1)
		$labelFormat:="SSCC_Arkay"
	Else 
		$labelFormat:="SSCC_PFS"
	End if 
End if 

util_PAGE_SETUP(->[WMS_SerializedShippingLabels:96]; $labelFormat)

//SET PRINT OPTION(Number of copies option;$numLabels)
PRINT SETTINGS:C106
//SET CURRENT PRINTER($printerNamePref)
//End if 
If (ok=1)
	
	If ([WMS_SerializedShippingLabels:96]ContainerType:13="SKID")
		If ([Finished_Goods:26]ProductCode:1#[WMS_SerializedShippingLabels:96]CPN:2)
			READ ONLY:C145([Finished_Goods:26])
			$numFound:=qryFinishedGood("#CPN"; [WMS_SerializedShippingLabels:96]CPN:2)
		End if 
		Print form:C5([WMS_SerializedShippingLabels:96]; $labelFormat)
	Else 
		Print form:C5([WMS_SerializedShippingLabels:96]; "GayLordLabel")
	End if 
	
End if 

//SET CURRENT PRINTER($printerName)
//wWindowTitle ("pop")
zwStatusMsg("Finished"; "SSCC = "+$sscc)  //+" to "+$printerName)
//End if 
