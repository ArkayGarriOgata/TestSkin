//%attributes = {"publishedWeb":true}
//PM: FG_PrintFolderLabelWithDriver() -> 
//@author mlb - 12/18/02  15:37

C_DATE:C307(dDate)
C_TIME:C306($docRef)
C_TEXT:C284($usePrinter; $path; $printerNamePref)

dDate:=4D_Current_date
FORM SET OUTPUT:C54([Finished_Goods_Specifications:98]; "Dymo_QA_Folder")
//next line cause it to spool to infinity:
//util_PAGE_SETUP(->[Finished_Goods_Specifications];"Dymo_QA_Folder")

$usePrinter:="DYMO LabelWriter 400"  //the default name
docName:="DymoPrinterPreference.txt"
$path:=util_DocumentPath("get")
If (Test path name:C476($path+docName)#Is a document:K24:1)
	ARRAY TEXT:C222(<>aPrinterNames; 0)
	PRINTERS LIST:C789(<>aPrinterNames)
	wWindowTitle("push"; "Pick the Dymo Printer")
	$winRef:=OpenSheetWindow(->[zz_control:1]; "SelectPrinter_dio")
	DIALOG:C40([zz_control:1]; "SelectPrinter_dio")
	CLOSE WINDOW:C154($winRef)
	wWindowTitle("pop")
	If (OK=1)
		$printerNamePref:=<>aPrinterNames{0}
	End if 
	
	If (OK=1) & (Length:C16($printerNamePref)>0)
		$docRef:=util_putFileName(->docName)
		If ($docRef#?00:00:00?)
			SEND PACKET:C103($docRef; $printerNamePref)
			CLOSE DOCUMENT:C267($docRef)
		End if 
	End if 
End if 
//get the user pref document
docName:="DymoPrinterPreference.txt"
$docRef:=Open document:C264($path+docName)
If ($docRef#?00:00:00?)
	RECEIVE PACKET:C104($docRef; $usePrinter; 255)
	CLOSE DOCUMENT:C267($docRef)
	$usePrinter:=Replace string:C233($usePrinter; Char:C90(13); "")
	
Else 
	$usePrinter:="DYMO LabelWriter 400"
End if 

$useLabel4x2:="30256 Shipping"
$useLandScapeOrientation:=2  //landscape
$holdPrinterName:=""
$holdOrientation:=0
$holdPaper:=""
$holdPrinterName:=Get current printer:C788
GET PRINT OPTION:C734(Orientation option:K47:2; $holdOrientation)
GET PRINT OPTION:C734(Paper option:K47:1; $holdPaper)

SET CURRENT PRINTER:C787($usePrinter)
$newPrinterName:=Get current printer:C788

SET PRINT OPTION:C733(Orientation option:K47:2; $useLandScapeOrientation)  //landscape
SET PRINT OPTION:C733(Paper option:K47:1; $useLabel4x2)

PRINT RECORD:C71([Finished_Goods_Specifications:98])  //;*)

FORM SET OUTPUT:C54([Finished_Goods_Specifications:98]; "List")
SET CURRENT PRINTER:C787($holdPrinterName)
SET PRINT OPTION:C733(Orientation option:K47:2; $holdOrientation)  //landscape
SET PRINT OPTION:C733(Paper option:K47:1; $holdPaper)