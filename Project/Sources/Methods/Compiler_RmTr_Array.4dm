//%attributes = {}
//Method:  Compiler_RmTr_Array(tMethodName{;nRows}{;nColumns})
//Description:  This method initializes arrays

If (True:C214)  //Initialization
	
	C_TEXT:C284($1; $tMethodName)
	C_LONGINT:C283($2; $nRows; $3; $nColumns)
	C_LONGINT:C283($nNumberOfParameters)
	
	C_POINTER:C301($patTitle; $patLocation; $patKey)
	C_POINTER:C301($patQuryComparatorLast)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tMethodName:=$1
	
	$nRows:=0
	$nColumns:=0
	
	If ($nNumberOfParameters>=2)  //Optional
		$nRows:=$2
		If ($nNumberOfParameters>=3)
			$nColumns:=$3
		End if 
	End if   //Done optional
	
End if   //Done initialization

Case of   //Method name
		
	: ($tMethodName="RmTr_Foil_Fill")
		
		ARRAY TEXT:C222(RmTr_atFoil_Vendor; $nRows)
		ARRAY TEXT:C222(RmTr_atFoil_Width; $nRows)
		ARRAY TEXT:C222(RmTr_atFoil_Color; $nRows)
		ARRAY TEXT:C222(RmTr_atFoil_Quantity; $nRows)
		
End case   //Done method name
