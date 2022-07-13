//%attributes = {}
// Method: ZebraTestDriver () -> 
// ----------------------------------------------------
// by: mel: 12/01/04, 16:07:52
// ----------------------------------------------------
// Description:
// see if we can print to the zebra over the network with drivers from:

// Updates:

// ----------------------------------------------------

C_TEXT:C284($1; $currentPrinter)
ARRAY TEXT:C222($aLocation; 0)
ARRAY TEXT:C222($aModel; 0)

If (Count parameters:C259=0)
	$currentPrinter:=Get current printer:C788
	
	PRINTERS LIST:C789(<>aPrinterNames; $aLocation; $aModel)
	<>aPrinterNames{0}:=$currentPrinter
	<>aPrinterNames:=Find in array:C230(<>aPrinterNames; $currentPrinter)
	
	$winRef:=Open form window:C675([zz_control:1]; "SelectPrinter_dio")
	
	$cr:=Char:C90(13)
	tFrom:="Arkay Packaging Corporation"+$cr
	tFrom:=tFrom+"350 East Park Drive"+$cr
	tFrom:=tFrom+"Roanoke  VA  24019 USA"
	tto:="Mel Bohince"+$cr
	tto:=tto+"114 Murrysville Road"+$cr
	tto:=tto+"Level Green, PA 15085 USA"
	sCPN:="*1231-12-1233*"
	sDesc:="HARD TO USE STUFF"
	iQty:=1200
	sPO:="*890877.001.01*"
	sJMI:="*83123.01.03*"
	i:=3
	iItemNumber:=i
	iLastLabel:=10
	sOF:="123"
	dDate:=<>MAGIC_DATE
	READ ONLY:C145([WMS_Label_Tracking:75])
	ALL RECORDS:C47([WMS_Label_Tracking:75])
	If (Records in selection:C76([WMS_Label_Tracking:75])=0)
		CREATE RECORD:C68([WMS_Label_Tracking:75])
		[WMS_Label_Tracking:75]Jobit:7:="83123.01.03"
		SAVE RECORD:C53([WMS_Label_Tracking:75])
	End if 
	
	DIALOG:C40([zz_control:1]; "SelectPrinter_dio")
	CLOSE WINDOW:C154($winRef)
	
	SET CURRENT PRINTER:C787($currentPrinter)
	
Else 
	$pid:=New process:C317("ZebraTestDriver"; <>lMinMemPart; "Test Printer")
	If (False:C215)
		ZebraTestDriver
	End if 
End if 

