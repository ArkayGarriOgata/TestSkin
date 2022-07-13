//%attributes = {"invisible":true,"shared":true}
//Method:  Core_Array_FillWithValue(paFillArray;pValue{;nNumberOfElements}{;nStart})
//Description:  This method fills array with value.  If nNumberOfElements is not specified
//   then it just fills in the array if nNumberofElements is used then it will make sure the array
//   is resized up to the nNumberOfElements and fill those in with the value.
//   
//   Use this when you want to fill all elements in array with the same value.
//   note the types of the values must match.

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $paFillArray)
	C_POINTER:C301($2; $pValue)
	C_LONGINT:C283($3; $nNumberOfElements; $nSizeOfArray; $nElement)
	C_LONGINT:C283($4; $nStart)
	
	$paFillArray:=$1
	$pValue:=$2
	
	$nSizeOfArray:=Size of array:C274($paFillArray->)
	$nNumberOfElements:=$nSizeOfArray
	$nStart:=1
	
	If (Count parameters:C259>=3)
		$nNumberOfElements:=$3
		If (Count parameters:C259>=4)
			$nStart:=$4
		End if 
	End if 
	
End if   //Done Initialize

For ($nElement; $nStart; $nNumberOfElements)  //Loop thru array
	
	If ($nElement>$nSizeOfArray)  //Add
		
		APPEND TO ARRAY:C911($paFillArray->; $pValue->)
		
	Else   //Replace
		
		$paFillArray->{$nElement}:=$pValue->
		
	End if   //Done add
	
End for   //Done loop thru array