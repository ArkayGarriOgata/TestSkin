//%attributes = {}
//Method:  Core_Array_FromDocument (paColumn{;tDocumentName}{;tPathname})
//Description:  This method will fill arrays to a document that is opened
//   each column in the document is an array.  It assumes all columns are the 
//   same size.

//  Example: Document has three columns seperated by tabs

//    ARRAY POINTER($apColumn;0)
//    APPEND TO ARRAY($apColumn;->$atDatePurchased)
//    APPEND TO ARRAY($apColumn;->$atProduct)
//    APPEND TO ARRAY($apColumn;->$atProductPrice)

//    Core_Array_FromDocument (->$apColumn). //This will ask for file name and directory
//    Core_Array_FromDocument (->$apColumn;$tDocumentName). //This will ask for directory
//    Core_Array_FromDocument (->$apColumn;$tDocumentName;$tDirectory). //This will open document directly 

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $paColumn)
	C_TEXT:C284($2; $tDocumentName; $3; $tPathname)
	
	C_POINTER:C301($pColumn)
	C_TIME:C306($hDocumentReferenceID)
	
	C_LONGINT:C283($nColumn; $nNumberOfColumns)
	
	C_LONGINT:C283($nNumberOfParameters)
	
	C_TEXT:C284($tColumn; $tDocumentName; $tPathname)
	
	C_TEXT:C284($tStopChar)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$paColumn:=$1
	$tDocumentName:=CorektBlank
	$tPathname:=CorektBlank
	
	If ($nNumberOfParameters>=2)
		$tDocumentName:=$2
		If ($nNumberOfParameters>=3)
			$tPathname:=$3
		End if 
	End if 
	
	$nNumberOfColumns:=Size of array:C274($paColumn->)
	
End if   //Done initializing

$hDocumentReferenceID:=Open document:C264(CorektBlank)  //opens a document

If ($hDocumentReferenceID#?00:00:00?)
	
	While (OK=1)  //Rows
		
		For ($nColumn; 1; $nNumberOfColumns)  //Columns
			
			$pColumn:=$paColumn->{$nColumn}
			
			$tStopChar:=Choose:C955($nColumn=$nNumberOfColumns; Char:C90(Line feed:K15:40); Char:C90(Tab:K15:37))
			
			RECEIVE PACKET:C104($hDocumentReferenceID; $tColumn; $tStopChar)
			
			APPEND TO ARRAY:C911($pColumn->; $tColumn)
			
		End for   //Done columns
		
	End while   //Done rows
	
	CLOSE DOCUMENT:C267($hDocumentReferenceID)
	
End if 