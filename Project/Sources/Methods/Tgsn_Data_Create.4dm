//%attributes = {}
//Method:  Tgsn_Data_Create
//Description:  This method will create the array information for
//.  the Tgsn_Data_Column method.
//. Data is the column names and orders.
//. It is imperative to make sure the data is in the exact order of their requirements

If (True:C214)  //Initialize
	C_TIME:C306($hDocumentReference)
	
	C_TEXT:C284($tCodeObject; $tColumn)
	C_TEXT:C284($tMessage; $tPathname)
	
	$tCodeObject:=CorektBlank
	$tColumn:=CorektBlank
	$tMessage:=CorektBlank
	$tPathname:=CorektBlank
	
End if   //Done Initialize

$hDocumentReference:=Open document:C264("")

Repeat 
	
	RECEIVE PACKET:C104($hDocumentReference; $tColumn; CorektComma)
	
	$tCodeObject:=$tCodeObject+"OB SET(TgsnoColumn;"+Char:C90(Double quote:K15:41)+$tColumn+Char:C90(Double quote:K15:41)+";CorektBlank)"+Char:C90(Carriage return:K15:38)
	
Until (OK=0)

CLOSE DOCUMENT:C267($hDocumentReference)

$tPathname:=Select folder:C670($tMessage)

TEXT TO DOCUMENT:C1237($tPathname+"Tgsn_Data_ColumnObjectCode"; $tCodeObject)