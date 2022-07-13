//%attributes = {"invisible":true,"shared":true}
//Method:  Core_Macro_CompilerDeclarationT(sMethodName;tParameterDeclaration)=>tCompilerDeclaration
//Description:  This method creates the method compiler declaration

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tMethodName)
	C_TEXT:C284($tModuleAcronym; $tStartsWith)
	
	C_TEXT:C284($2; $tParameterDeclaration; $0; $tCompilerDeclaration)
	
	$tMethodName:=$1
	$tParameterDeclaration:=$2
	
	$tModuleAcronym:=Substring:C12($tMethodName; 1; 5)  //Modl_
	
	$tStartsWith:=$tMethodName[[6]]
	
End if   //Done Initialize

If ($tStartsWith<"M")  //Which compiler Method AL or MZ
	$tCompilerDeclaration:="Compiler_"+$tModuleAcronym+"MethodAL"
Else   //MZ
	$tCompilerDeclaration:="Compiler_"+$tModuleAcronym+"MethodMZ"
End if   //Done which compiler method AL or MZ

$tCompilerDeclaration:=$tCompilerDeclaration+CorektDoubleSpace

$tCompilerDeclaration:=$tCompilerDeclaration+Replace string:C233($tParameterDeclaration; "("; "("+$tMethodName+";")

$0:=$tCompilerDeclaration