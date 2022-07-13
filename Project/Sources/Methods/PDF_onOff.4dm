//%attributes = {}
// Method: PDF_onOff () -> 
// ----------------------------------------------------
// by: mel: 09/02/03, 11:12:59
//see also PDF_setUp
// ----------------------------------------------------
// Description:
// turn on or off the switch that PDF_setUp uses to decide if it is active or not,
// this is to replace the Chooser based drv called Print2PDF of OS9's age
// ----------------------------------------------------

C_LONGINT:C283(OK)
C_BOOLEAN:C305(<>PrintToPDF)

If (<>PrintToPDF)
	CONFIRM:C162("Print destination is current set to PDF. Change?"; "Printer"; "PDF")
	If (OK=1)
		<>PrintToPDF:=False:C215
	End if 
	
Else 
	CONFIRM:C162("Print destination is current set to Printer. Change?"; "Printer"; "PDF")
	If (OK=0)
		<>PrintToPDF:=True:C214
	End if 
End if 

If (<>PrintToPDF)
	C_LONGINT:C283($macPDF; $printer)
	$macPDF:=3
	$prefPath:=util_DocumentPath
	$pdfDocName:="aMsOutput"+String:C10(TSTimeStamp)+".pdf"
	SET PRINT OPTION:C733(Destination option:K47:7; $macPDF; ($prefPath+$pdfDocName))
Else 
	$printer:=1
	SET PRINT OPTION:C733(Destination option:K47:7; $printer; "")
End if 