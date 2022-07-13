//%attributes = {}
//Method:  Core_Convert_BooleanT(bBoolean{;tTrue}{;tFalse})=> "True" or "False"
//Description:  This function converts a boolean to the word True or False

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($1; $bValue)
	C_TEXT:C284($tBooleanExpression; $0; $2; $3; $tTrue; $tFalse)
	
	$bValue:=$1
	$tTrue:="True"
	$tFalse:="False"
	
	If (Count parameters:C259>1)
		$tTrue:=$2
		$tFalse:=$3
	End if 
	
	$tBooleanExpression:=CorektBlank
	
End if   //Done Initialize

$tBooleanExpression:=Choose:C955($bValue; $tTrue; $tFalse)

$0:=$tBooleanExpression