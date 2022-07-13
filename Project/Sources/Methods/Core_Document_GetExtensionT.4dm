//%attributes = {}
//Method:  Core_Document_GetExtensionT ({tFilename})=>tExtension
//Description:  This method will return the extension of a filename

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tFilename; $0; $tExtension)
	C_LONGINT:C283($nNumberOfParameters; $nPeriod)
	
	$tExtension:=CorektBlank
	$tFilename:=Document
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=1)
		$tFilename:=$1
	End if 
	
End if   //Done Initialize

$nPeriod:=Position:C15(CorektPeriod; $tFilename)

$tExtension:=Substring:C12($tFilename; $nPeriod+1)

$0:=$tExtension


