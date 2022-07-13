//%attributes = {}
//Method:  Core_Array_Remove(paValue;pRemoveValue)
//Description:  This method loops thru array and removes value from it

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $paValue)
	C_POINTER:C301($2; $pRemoveValue)
	
	C_LONGINT:C283($nElement; $nLastElement)
	
	$paValue:=$1
	$pRemoveValue:=$2
	
	$nLastElement:=Size of array:C274($paValue->)
	
End if   //Done initialize

For ($nElement; $nLastElement; 1; -1)
	
	If ($paValue->{$nElement}=$pRemoveValue->)
		
		DELETE FROM ARRAY:C228($paValue->; $nElement)
		
	End if 
	
End for 
