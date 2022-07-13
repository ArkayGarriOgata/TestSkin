//%attributes = {}
//Method:  Compiler_Arky_Array(tMethodName{;nRows}{;nColumns})
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
		
	: (($tMethodName="Arky_Prcs_LoadHList1") | ($tMethodName="Arky_Prcs_LoadTable"))
		
		ARRAY TEXT:C222(Arky_atPrcs_TableField; $nRows)
		ARRAY TEXT:C222(Arky_atPrcs_TableName; $nRows)
		ARRAY TEXT:C222(Arky_atPrcs_FieldName; $nRows)
		
	: ($tMethodName="Arky_Prcs_LoadHList1Parameter")
		
		ARRAY POINTER:C280(Arky_apPrcs_Parameter1; $nRows)
		
	: ($tMethodName="Arky_Prcs_LoadHList2")
		
		ARRAY TEXT:C222(Arky_atPrcs_ArkyProcessKey; $nRows)
		ARRAY TEXT:C222(Arky_atPrcs_Category; $nRows)
		ARRAY TEXT:C222(Arky_atPrcs_Title; $nRows)
		ARRAY TEXT:C222(Arky_atPrcs_Description; $nRows)
		
	: ($tMethodName="Arky_Prcs_LoadHList2Parameter")
		
		ARRAY POINTER:C280(Arky_apPrcs_Parameter2; $nRows)
		
End case   //Done method name

