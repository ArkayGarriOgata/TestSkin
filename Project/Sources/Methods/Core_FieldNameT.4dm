//%attributes = {}
//Method: Core_FieldNameT(pField)=>tFieldName
//Description: This method returns [Table]FieldName

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pField)
	C_TEXT:C284($0; $tFieldName)
	
	C_TEXT:C284($tTable; $tField)
	
	$pField:=$1
	
	$tFieldName:=CorektBlank
	
	$tTable:=Table name:C256(Table:C252($pField))
	$tField:=Field name:C257($pField)
	
End if   //Done Initialize

$tFieldName:="["+$tTable+"]"+$tField

$0:=$tFieldName