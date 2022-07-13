//%attributes = {}
//Method:  Compiler_UsSp_Array(tMethodName{;nRows}{;nColumns})
//Description:  This method initializes arrays

If (True:C214)  //Initialize
	
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
	
End if   //Done Initialize

Case of   //Method name
		
	: ($tMethodName="UsSp_Entry_Category")
		
		ARRAY TEXT:C222(UsSp_atEntry_Category; $nRows)
		
	: ($tMethodName="UsSp_Entry_Initialize")
		
		ARRAY TEXT:C222(UsSp_atEntry_Attachment; $nRows)
		
End case   //Done method name
