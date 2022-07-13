//%attributes = {}
//Method:  Core_Code_GetTableFieldArrayN(tTableFieldArrayName)=>nTableFieldArrayType
//Descripton:  This method returns if the text of an object is a table, field or aray

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tObject)
	C_LONGINT:C283($0; $nTableFieldArrayType)
	
	$tObject:=$1
	$nTableFieldArrayType:=0
	
End if   //Done Initialize

Case of   //TableFieldArray
		
	: ((Position:C15("["; $tObject)=1) & (Position:C15("]"; $tObject)=Length:C16($tObject)))  //Table
		
		$nTableFieldArrayType:=CoreknCodeTable
		
	: ((Position:C15("["; $tObject)=1) & (Position:C15("]"; $tObject)<Length:C16($tObject)))  //Field
		
		$nTableFieldArrayType:=CoreknCodeField
		
	: (Position:C15("["; $tObject)=0)  //Array
		
		$nTableFieldArrayType:=CoreknCodeArray
		
End case   //Done TableFieldArray

$0:=$nTableFieldArrayType