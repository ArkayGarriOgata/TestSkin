//%attributes = {}
//Method:  Core_Array_ToDocument (paColumn{;tDocumentName}{;tPathname})
//Description:  This method will store arrays to a document where
//   each array is a column in the document.  It assumes all columns are the 
//   same size.

//  Example:

//    ARRAY POINTER($apColumn;0)
//    APPEND TO ARRAY($apColumn;->$atDatePurchased)
//    APPEND TO ARRAY($apColumn;->$atProduct)
//    APPEND TO ARRAY($apColumn;->$atProductPrice)
//    Core_Array_ToDocument (->$apColumn). //This will ask for file name and directory
//    Core_Array_ToDocument (->$apColumn;$tDocumentName). //This will ask for directory
//    Core_Array_ToDocument (->$apColumn;$tDocumentName;$tDirectory). //This will create or overwrite 

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $paColumn)
	C_TEXT:C284($2; $tDocumentName; $3; $tPathname)
	C_POINTER:C301($pColumn)
	C_TIME:C306($hDocumentReferenceID)
	
	C_LONGINT:C283($nNumberOfRows; $nRow)
	C_LONGINT:C283($nColumn; $nNumberOfColumns)
	
	C_LONGINT:C283($nNumberOfParameters)
	
	C_OBJECT:C1216($oPath)
	
	C_TEXT:C284($tColumn; $tRow; $tDocumentName; $tPathname)
	
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
	
	$oPath:=New object:C1471()
	
	$oPath.tDocumentName:=$tDocumentName
	$oPath.tPathName:=$tPathname
	
End if   //Done initializing

$hDocumentReferenceID:=Core_Document_GetPathReferenceH($oPath)

If ($hDocumentReferenceID#?00:00:00?)
	
	$nNumberOfColumns:=Size of array:C274($paColumn->)
	
	$pColumn:=$paColumn->{1}
	
	$nNumberOfRows:=Size of array:C274($pColumn->)
	
	For ($nRow; 1; $nNumberOfRows)  //Loop through rows
		
		$tRow:=CorektBlank
		
		For ($nColumn; 1; $nNumberOfColumns)  //Loop through columns
			
			$pColumn:=$paColumn->{$nColumn}
			
			$tColumn:=Core_Convert_ToTextT($pColumn; $nRow)
			
			$tRow:=$tRow+$tColumn+Char:C90(Tab:K15:37)
			
		End for   //Done looping through columns
		
		$tRow:=Substring:C12($tRow; 1; Length:C16($tRow)-1)  //Remove the last tab
		
		$tRow:=$tRow+Char:C90(Carriage return:K15:38)
		
		SEND PACKET:C103($hDocumentReferenceID; $tRow)
		
	End for   //Done looping thru rows
	
	CLOSE DOCUMENT:C267($hDocumentReferenceID)
	
End if 