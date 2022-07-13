//%attributes = {}
//Method:  Compiler_Rprt_Array(tMethodName{;nRows}{;nColumns})
//Description:  This method initializes arrays

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tMethodName)
	C_LONGINT:C283($2; $nRows; $3; $nColumns)
	C_LONGINT:C283($nNumberOfParameters)
	
	C_POINTER:C301($patTitle; $patLocation; $patKey)
	C_POINTER:C301($patQuryComparatorLast)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tMethodName:=$1
	
	$nRows:=0
	$nColumns:=0
	
	If ($nNumberOfParameters>=2)
		$nRows:=$2
		If ($nNumberOfParameters>=3)
			$nColumns:=$3
		End if 
	End if   //Done optional
	
End if   //Done initialize

Case of   //Method name
		
	: ($tMethodName="Rprt_Entry_Initialize")
		
		ARRAY TEXT:C222(Rprt_atEntry_Group; $nRows)
		ARRAY TEXT:C222(Rprt_atEntry_Category; $nRows)
		
	: (($tMethodName="Rprt_Pick_Initialize") | ($tMethodName="Rprt_Pick_Manager"))
		
		ARRAY TEXT:C222(Rprt_Pick_atValue0; $nRows)
		
	: ($tMethodName="Rprt_Pick_LoadHList")
		
		ARRAY POINTER:C280(RprtapParameter; $nRows)
		
End case   //Done method name

