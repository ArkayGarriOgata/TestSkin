//%attributes = {}
//Method:  Core_Cltn_GetTypeN(cValue;nRow{;nColumn}=>nType
//Description:  This method will return the type of value
//  in a collection based on its row and column

//Note: If you want to pass in a collection
//      that has only one column pass in the number 0
//      0 is the default value

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($1; $cValue)
	C_LONGINT:C283($2; $nRow; $3; $nColumn)
	C_LONGINT:C283($0; $nType)
	
	C_LONGINT:C283($nNumberOfParameters)
	
	$cValue:=$1
	$nRow:=$2
	$nColumn:=0
	$nType:=0
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=3)  //Parameters
		
		$nColumn:=$3
		
	End if   //Done parameters
	
End if   //Done initialize

If ($nColumn=0)
	
	$nType:=Value type:C1509($cValue[$nRow])
	
Else 
	
	$nType:=Value type:C1509($cValue[$nColumn][$nRow])
	
End if 

$0:=$nType