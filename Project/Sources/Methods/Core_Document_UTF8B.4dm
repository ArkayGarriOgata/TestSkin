//%attributes = {}
//Method: Core_Document_Utf8B(oUTF8)=>bDocumentCreated
//Description:  This will create a UTF-8 document
//  and return True if document is created

//   oUTF8.ptDocumentInfo (Document information in text form
//   oUTF8.bUseBOM (False saves as UTF-8 without BOM)
//   oUTF8.tPathname (If not specified brings up select folder)
//   oUTF8.tFilename (If not specified will ask for name of document)
//   oUTF8.tExtension (Defaults to txt)

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oUTF8)
	C_BOOLEAN:C305($0; $bDocumentCreated)
	
	C_BOOLEAN:C305($bUseBOM)
	C_TEXT:C284($tPathname; $tFilename; $tExtension)
	C_BLOB:C604($lDocumentInfo)
	
	C_OBJECT:C1216($oAsk)
	C_LONGINT:C283($nRequestButton)
	
	$oAsk:=New object:C1471()
	$oAsk.tMessage:="Please enter a filename."
	$oAsk.tValue:="Filename"
	
	$oUTF8:=$1
	
	$tDocumentInfo:=Choose:C955(OB Is defined:C1231($oUTF8; "tDocumentInfo"); $oUTF8.tDocumentInfo; CorektBlank)
	
	$bUseBOM:=Choose:C955(OB Is defined:C1231($oUTF8; "bUseBOM"); $oUTF8.bUseBOM; True:C214)
	
	$tPathname:=Choose:C955(OB Is defined:C1231($oUTF8; "tPathname"); $oUTF8.tPathname; CorektBlank)
	
	$tFilename:=Choose:C955(OB Is defined:C1231($oUTF8; "tFilename"); $oUTF8.tFilename; CorektBlank)
	
	$tExtension:=Choose:C955(OB Is defined:C1231($oUTF8; "tExtension"); $oUTF8.tExtension; ".txt")
	
	$bDocumentCreated:=False:C215
	
End if   //Done Initialize

If ($tPathname=CorektBlank)  //No pathname
	
	$tPathname:=Select folder:C670()
	
End if   //Done no pathname

If ($tFilename=CorektBlank)  //No filename
	
	$nRequestButton:=Core_Dialog_RequestN($oAsk; ->$tFilename)
	
End if   //Done no filename

If ($bUseBOM)  //Use BOM
	
	TEXT TO DOCUMENT:C1237($tPathname+Folder separator:K24:12+$tFilename+CorektPeriod+$tExtension; $tDocumentInfo)  //Defaults to UTF8 with BOM
	
Else   //No BOM
	
	CONVERT FROM TEXT:C1011($tDocumentInfo; "UTF-8"; $lDocumentInfo)
	
	BLOB TO DOCUMENT:C526($tPathname+$tFilename+$tExtension; $lDocumentInfo)
	
End if   //Done use BOM

$0:=$bDocumentCreated