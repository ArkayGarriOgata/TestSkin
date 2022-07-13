//%attributes = {}
//Method:  Arcv_Field_ValidB(nTableNumber;tFieldName)=>bValid
//Description:  This method will check if the field can be set to the value stored
//. Some field types like Picture, Blobs and objects are currently not allowed

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nTableNumber)
	C_TEXT:C284($2; $tFieldName)
	C_BOOLEAN:C305($0; $bValid)
	
	$nTableNumber:=$1
	$tFieldName:=$2
	
	$bValid:=False:C215
	
End if   //Done initialize

$nFieldNumber:=Core_Field_GetFieldNumberN($nTableNumber; $tFieldName)

$nFieldType:=(Type:C295(Field:C253($nTableNumber; $nFieldNumber)->))

Case of   //Valid
		
	: ($nFieldType=Is BLOB:K8:12)
		
	: ($nFieldType=Is object:K8:27)
		
	: ($nFieldType=Is picture:K8:10)
		
	Else   //Good
		
		$bValid:=True:C214
		
End case   //Done valid


Core_Table_GetTableNumberN
$0:=$bValid