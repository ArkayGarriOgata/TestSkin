//%attributes = {}
// _______
// Method: app_SelectPrinter   ( ) ->
// By: Mel Bohince @ 04/15/19, 08:58:54
// Description
// toggle printer options to and from labelwriter
// ----------------------------------------------------
// Modified by: MelvinBohince (4/20/22)  set options for load labels

C_TEXT:C284($1; $printerNamePref; $useLabel4x2; $holdPaper)
C_LONGINT:C283($winRef; $useLandScapeOrientation; $holdOrientation)
C_OBJECT:C1216(<>lastPickedPrinter)

Case of 
	: ($1="pick")
		If (OB Is empty:C1297(<>lastPickedPrinter))
			
			ARRAY TEXT:C222(<>aPrinterNames; 0)
			PRINTERS LIST:C789(<>aPrinterNames)
			wWindowTitle("push"; "Pick the Dymo Printer")
			$winRef:=OpenSheetWindow(->[zz_control:1]; "SelectPrinter_dio")
			DIALOG:C40([zz_control:1]; "SelectPrinter_dio")
			CLOSE WINDOW:C154($winRef)
			wWindowTitle("pop")
			If (OK=1)
				<>lastPickedPrinter:=New object:C1471
				<>lastPickedPrinter.name:=<>aPrinterNames{0}
				<>lastPickedPrinter.paper:="30256 Shipping"  //default for dieboard labels
				<>lastPickedPrinter.orientation:=1  //portrait
				
				$holdOrientation:=0
				$holdPaper:=""
				<>resetToPrinter:=New object:C1471
				<>resetToPrinter.name:=Get current printer:C788
				GET PRINT OPTION:C734(Orientation option:K47:2; $holdOrientation)
				GET PRINT OPTION:C734(Paper option:K47:1; $holdPaper)
				<>resetToPrinter.paper:=$holdPaper
				<>resetToPrinter.orientation:=$holdOrientation
			End if 
		End if 
		
		If (Not:C34(OB Is empty:C1297(<>lastPickedPrinter)))
			SET CURRENT PRINTER:C787(<>lastPickedPrinter.name)
			SET PRINT OPTION:C733(Orientation option:K47:2; <>lastPickedPrinter.orientation)
			SET PRINT OPTION:C733(Paper option:K47:1; <>lastPickedPrinter.paper)
			ok:=1
		End if 
		
	: ($1="load-label")  // Modified by: MelvinBohince (4/20/22) 
		SET PRINT OPTION:C733(Orientation option:K47:2; 2)
		SET PRINT OPTION:C733(Paper option:K47:1; "30252 Address")
		
	: ($1="reset")
		If (Not:C34(OB Is empty:C1297(<>resetToPrinter)))
			SET CURRENT PRINTER:C787(<>resetToPrinter.name)
			SET PRINT OPTION:C733(Orientation option:K47:2; <>resetToPrinter.orientation)
			SET PRINT OPTION:C733(Paper option:K47:1; <>resetToPrinter.paper)
		End if 
End case 
