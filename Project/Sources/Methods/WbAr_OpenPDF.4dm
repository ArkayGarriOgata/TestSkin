//%attributes = {}
//Method:  WbAr_OpenPDF(oWebArea)
//Description:  This method will open a pdf in a web area
// tPathToPDF - is the pathname to the pdf

//Example:

//    C_OBJECT($oOpenPDF)

//    $oOpenPDF:=New object()

//    $oOpenPDF.tPathToPDF:=System folder(Documents folder)+"AMS_Documents"+Folder separator+"aMs_Help"+Folder separator+"MyDocument.pdf"

//    WbAr_OpenPDF ($oOpenPDF)

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oWebArea)
	
	C_TEXT:C284($tWebAreaName; $tPathToPDF)
	
	$oWebArea:=$1
	
	$tWebAreaName:=Choose:C955(\
		OB Is defined:C1231($oWebArea; "tWebAreaName"); \
		$oWebArea.tWebAreaName; \
		"Web Area")
	
	$tPathToPDF:=Choose:C955(\
		OB Is defined:C1231($oWebArea; "tPathToPDF"); \
		$oWebArea.tPathToPDF; \
		CorektBlank)
	
End if   //Done initialize

Case of   //Verify
		
	: ($tWebAreaName=CorektBlank)
	: ($tPathToPDF=CorektBlank)
		
	Else   //Play
		
		WA OPEN URL:C1020(*; $tWebAreaName; $tPathToPDF)
		
End case   //Done verify
