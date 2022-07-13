//%attributes = {}
//Method:  Compiler_Help_Array(tMethodName{;nRows}{;nColumns})
//Description:  This method initializes arrays

If (True:C214)  //Initialization
	
	C_TEXT:C284($1; $tMethodName)
	C_LONGINT:C283($2; $nRows; $3; $nColumns)
	C_LONGINT:C283($nNumberOfParameters)
	
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
		
	: ($tMethodName="Help_View_LoadHList")
		
		ARRAY POINTER:C280(HelpapParameter; $nRows)
		
	: ($tMethodName="Help_Entr_LoadHList")
		
		ARRAY POINTER:C280(HelpapParameter; $nRows)
		
End case   //Done method name

