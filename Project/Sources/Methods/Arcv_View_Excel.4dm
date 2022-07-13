//%attributes = {}
//Method:  Arcv_View_Excel
//Description:  This method will open the record information in Excel
//  It expects Arcv_atView_Field and Arcv_atView_Value to be defined
//  Relies on the document (4D process variable)

If (True:C214)  //Initialize
	
	C_TEXT:C284($tDocumentName; $tDirectory)
	C_TIME:C306($hDocument)
	
	ARRAY POINTER:C280($apColumn; 0)
	
	APPEND TO ARRAY:C911($apColumn; ->Arcv_atView_Field)
	APPEND TO ARRAY:C911($apColumn; ->Arcv_atView_Value)
	
End if   //Done initialize

$hDocument:=Create document:C266(CorektBlank)
CLOSE DOCUMENT:C267($hDocument)

$tDocumentName:=Core_Document_GetNameT(document)+CorektPeriod+Core_Document_GetExtensionT(document)
$tDirectory:=Substring:C12(Document; 1; Position:C15($tDocumentName; document)-1)

Core_Array_ToDocument(->$apColumn; $tDocumentName; $tDirectory)

OPEN URL:C673(document; "Microsoft Excel"; *)
