//%attributes = {}
//Method:  Compiler_Tgsn_Array(tMethodName{;nRows}{;nColumns})
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
		
	: ($tMethodName="Tgsn_Verify_LoadColumn")
		
		ARRAY BOOLEAN:C223(Tgsn_abVerify; $nRows)  //ListBox arrays
		ARRAY LONGINT:C221(Tgsn_anVerify_RowControl; $nRows)
		ARRAY LONGINT:C221(Tgsn_anVerify_RowBackground; $nRows)
		
		ARRAY BOOLEAN:C223(Tgsn_abVerify_Send; $nRows)  //Column arrays
		ARRAY BOOLEAN:C223(Tgsn_abVerify_Fix; $nRows)
		ARRAY LONGINT:C221(Tgsn_anVerify_InvoiceNumber; $nRows)
		
End case   //Done method name

