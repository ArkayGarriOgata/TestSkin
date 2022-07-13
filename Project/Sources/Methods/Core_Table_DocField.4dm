//%attributes = {}
//Core_Table_DocField(pTable)
//Description:  This method will create a document of [Table]Field for pTable

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pTable)
	
	C_LONGINT:C283($nField; $nNumberOfFields)
	C_LONGINT:C283($nTable)
	
	ARRAY TEXT:C222($atField; 0)
	
	ARRAY POINTER:C280($apColumn; 0)
	APPEND TO ARRAY:C911($apColumn; ->$atField)
	
	$pTable:=$1
	
	$nTable:=Table:C252($pTable)
	
	$nNumberOfFields:=Get last field number:C255($nTable)
	
End if   //Done initialize

For ($nField; 1; $nNumberOfFields)  //Fields
	
	If (Is field number valid:C1000($nTable; $nField))  //Valid field
		
		$pField:=Field:C253($nTable; $nField)
		
		APPEND TO ARRAY:C911($atField; Core_FieldNameT($pField))
		
	End if   //Done valid field
	
End for   //Done fields

Core_Array_ToDocument(->$apColumn)