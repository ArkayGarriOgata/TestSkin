//%attributes = {}
//Method:  Compiler_WbAr_Array(tMethodName{;nRows}{;nColumns})
//Description:  This method initializes arrays

If (True:C214)  //Initialization
	
	C_TEXT:C284($1; $tMethodName)
	C_LONGINT:C283($2; $nRows; $3; $nColumns)
	C_LONGINT:C283($nNumberOfParameters)
	
	C_POINTER:C301($patTitle; $patLocation; $patKey)
	
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
		
	: ($tMethodName="WbAr_Video_Initialize")
		
		ARRAY TEXT:C222(WbAr_Video_atFilePathName; $nRows)
		
End case   //Done method name
