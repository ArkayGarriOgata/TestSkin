//%attributes = {}
//Method:  Core_Variable_DefaultT(pVariable{;tVariableType})=>tDefaultSetting
//Description:  This method returns the default for a pointer to avariable or tType
//Example:   Core_Variable_DefaultT(->$tVariable)=>CorektBlank
//           Core_Variable_DefaultT(Null;CorektTypeDate)=>"!00/00/00!

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pVariable)
	C_TEXT:C284($2; $tVariableType)
	C_TEXT:C284($0; $tDefaultSetting)
	
	C_LONGINT:C283($nNumberOfParameters)
	
	C_TEXT:C284($tVariableName)
	C_LONGINT:C283($nTable; $nField)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$pVariable:=$1
	$tVariableType:=CorektBlank
	
	If ($nNumberOfParameters>=2)  //Optional parameters
		$tVariableType:=$2
	End if   //Done optional parameters
	
	$tDefaultSetting:=CorektBlank
	
	If ($tVariableType=CorektBlank)  //Get variable type
		
		RESOLVE POINTER:C394($pVariable; $tVariableName; $nTable; $nField)
		
		$tVariableType:=Core_Variable_GetTypeT($tVariableName; True:C214)
		
	End if   //Done get variable type
	
End if   //Done Initialize

Case of   //Variable type
		
	: ($tVariableType=CorektTypeText)
		
		$tDefaultSetting:="CorektBlank"
		
	: (($tVariableType=CorektTypeReal) | ($tVariableType=CorektTypeLongint))
		
		$tDefaultSetting:="0"
		
	: ($tVariableType=CorektTypeDate)
		
		$tDefaultSetting:="!00/00/00!"
		
	: ($tVariableType=CorektTypeTime)
		
		$tDefaultSetting:="†00:00:00†"
		
	: ($tVariableType=CorektTypeBoolean)
		
		$tDefaultSetting:="False"
		
	: ($tVariableType=CorektTypeBlob)
		
		$tDefaultSetting:=CorektBlank
		
	: ($tVariableType=CorektTypePicture)
		
		$tDefaultSetting:=CorektBlank
		
	: ($tVariableType=CorektTypePointer)
		
		$tDefaultSetting:="Null"
		
End case   //Done variable type

$0:=$tDefaultSetting