//%attributes = {}
//Method: Core_Array_Union(paSource1;paSource2/paUnion{;paUnion})
//Description:  This method will compare two arrays and combine them to one with unique values

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $paSource1)
	C_POINTER:C301($2; $paSource2)
	C_POINTER:C301($3; $paUnion)
	
	C_BOOLEAN:C305($bTypesMatch)
	C_LONGINT:C283($nNumberOfParameters)
	
	$paSource1:=$1
	$paSource2:=$2
	
	$nNumberOfParameters:=Count parameters:C259
	
	$bTypesMatch:=(Type:C295($paSource1->)=Type:C295($paSource2->))
	
	Case of   //Parameters
			
		: (Not:C34($bTypesMatch))
			
		: ($nNumberOfParameters>=3)
			
			$paUnion:=$3
			
			$bTypesMatch:=(Type:C295($paSource1->)=Type:C295($paUnion->))
			
	End case   //Done parameters
	
End if   //Done initialize

Case of   //Union
		
	: (Not:C34($bTypesMatch))
		
	: ($nNumberOfParameters=2)  //Union 2 arrays result in second array
		
		$nNumberOfSources:=Size of array:C274($paSource1->)
		
		For ($nSource; 1; $nNumberOfSources)  //Array1
			
			If (Find in array:C230($paSource2->; $paSource1->{$nSource})=CoreknNoMatchFound)  //Add
				
				APPEND TO ARRAY:C911($paSource2->; $paSource1->{$nSource})
				
			End if   //Done add
			
		End for   //Done array1
		
	: ($nNumberOfParameters=3)  //Union 3 arrays
		
		$nNumberOfSources:=Size of array:C274($paSource1->)
		
		For ($nSource; 1; $nNumberOfSources)  //Array1
			
			If (Find in array:C230($paUnion->; $paSource1->{$nSource})=CoreknNoMatchFound)  //Add
				
				APPEND TO ARRAY:C911($paUnion->; $paSource1->{$nSource})
				
			End if   //Done add
			
		End for   //Done Array1
		
		$nNumberOfSources:=Size of array:C274($paSource2->)
		
		For ($nSource; 1; $nNumberOfSources)  //Array2
			
			If (Find in array:C230($paUnion->; $paSource2->{$nSource})=CoreknNoMatchFound)  //Add
				
				APPEND TO ARRAY:C911($paUnion->; $paSource2->{$nSource})
				
			End if   //Done add
			
		End for   //Done array2
		
End case   //Done union

