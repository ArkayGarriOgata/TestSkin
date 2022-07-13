//%attributes = {}
//Method:  Core_Array_EqualSizeB (pArray1;pArray2...)=>bEqualSize
//Description:  This method will compare the sizes of arrays
//. it returns true if the size of every array is the same and not 0

If (True:C214)  //Initialize 
	
	C_BOOLEAN:C305($0; $bEqualSize)
	C_POINTER:C301(${1})
	
	C_LONGINT:C283($nParameter; $nNumberOfParameters)
	C_LONGINT:C283($nSize; $nCorrectSize)
	
	$bEqualSize:=False:C215
	
	$nSize:=0
	$nCorrectSize:=0
	
	$nNumberOfParameters:=Count parameters:C259
	
End if   //Done Initialize

For ($nParameter; 1; $nNumberOfParameters)  //Parameters
	
	$nSize:=Size of array:C274((${$nParameter})->)
	
	Case of   //Size
			
		: ($nSize=0)
			
			$bEqualSize:=False:C215
			$nParameter:=$nNumberOfParameters+1
			
		: ($nParameter=1)
			
			$nCorrectSize:=$nSize
			$bEqualSize:=True:C214
			
		: ($nSize#$nCorrectSize)
			
			$bEqualSize:=False:C215
			$nParameter:=$nNumberOfParameters+1
			
		Else   //Everything is good
			
	End case   //Done size
	
End for   //Done parameters

$0:=$bEqualSize

