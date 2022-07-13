//%attributes = {}
//Method: Qury_View_Load({tLine}{;bUseBoolean})
//Description:  This method will load the arrays
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tLine)
	
	C_TEXT:C284($tLastLine)
	
	C_POINTER:C301($patCriterion)
	C_POINTER:C301($patConjunction)
	
	$tLine:=CorektBlank
	$bUseBoolean:=False:C215
	
	If (Count parameters:C259>=1)
		$tLine:=$1
		If (Count parameters:C259>=2)
			$bUseBoolean:=$2
		End if 
	End if 
	
	$tLastLine:=String:C10(CoreknQuryRowMax)
	
End if   //Done initialize

$patCriterion:=Get pointer:C304("Core_atQury_Criterion"+$tLine)

APPEND TO ARRAY:C911($patCriterion->; "=")
APPEND TO ARRAY:C911($patCriterion->; "#")

If (Not:C34($bUseBoolean))  //Boolean
	
	APPEND TO ARRAY:C911($patCriterion->; ">")
	APPEND TO ARRAY:C911($patCriterion->; ">=")
	APPEND TO ARRAY:C911($patCriterion->; "<")
	APPEND TO ARRAY:C911($patCriterion->; "<=")
	
End if   //Done boolean

If ($tLine<$tLastLine)
	
	$patConjunction:=Get pointer:C304("Qury_View_atConjunction"+$tLine)
	
	APPEND TO ARRAY:C911($patConjunction->; CorektBlank)
	APPEND TO ARRAY:C911($patConjunction->; "&")
	APPEND TO ARRAY:C911($patConjunction->; "|")
	
End if 
