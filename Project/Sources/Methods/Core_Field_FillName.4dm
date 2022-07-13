//%attributes = {}
//Method:  Core_Field_FillName(nTable;patFieldName)
//Description:  This method will fill field name given table number

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nTable)
	C_POINTER:C301($2; $patFieldName)
	
	C_LONGINT:C283($nField; $nNumberOfFields)
	
	$nTable:=$1
	$patFieldName:=$2
	
	$nNumberOfFields:=Get last field number:C255($nTable)
	
End if   //Done initialize

For ($nField; 1; $nNumberOfFields)  //Fields
	
	If (Is field number valid:C1000($nTable; $nField))  //Valid field
		
		APPEND TO ARRAY:C911($patFieldName->; Field name:C257($nTable; $nField))
		
	End if   //Done valid field
	
End for   //Done fields
