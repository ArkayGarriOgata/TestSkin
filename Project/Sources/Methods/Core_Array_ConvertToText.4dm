//%attributes = {}
//Method:  Core_Array_ConvertToText(paSource;patDestination)
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_POINTER:C301($1; $paSource; $2; $patDestination)
	
	$paSource:=$1
	$patDestination:=$2
	
	$nTypeSource:=Type:C295($paSource->)
	
	$nNumberOfSources:=Size of array:C274($paSource->)
	
End if   //Done Initialize

For ($nSource; 1; $nNumberOfSources)  //Sources
	
	APPEND TO ARRAY:C911($patDestination->; String:C10($paSource->{$nSource}))
	
End for   //Done sources

