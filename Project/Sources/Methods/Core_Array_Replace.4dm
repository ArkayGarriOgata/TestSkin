//%attributes = {}
//Method: Core_Array_Replace(patValue;tOldValue;tNewValue)
//Description:  This method wil replace old value with new value in all array elements

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patValue)
	C_TEXT:C284($2; $tOldValue)
	C_TEXT:C284($3; $tNewValue)
	
	$patValue:=$1
	$tOldValue:=$2
	$tNewValue:=$3
	
	$nNumberOfValues:=Size of array:C274($patValue->)
	
End if   //Done Initialize

For ($nValue; 1; $nNumberOfValues)  //Loop thru values
	
	$patValue->{$nValue}:=Replace string:C233($patValue->{$nValue}; $tOldValue; $tNewValue; *)  //* indicates all occurrences
	
End for   //Done looping thru values
