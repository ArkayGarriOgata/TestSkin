//%attributes = {}
//Method:  Core_VdVl_SetValidValue(tCategory;tIdentifier;oValidValue)
//Description:  This method will set a valid value for a category and identifier

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tCategory)
	C_TEXT:C284($2; $tIdentifier)
	C_OBJECT:C1216($3; $oValidValue)
	
	C_OBJECT:C1216($eCore_ValidValue)
	C_OBJECT:C1216($oResult)
	
	$tCategory:=$1
	$tIdentifier:=$2
	$oValidValue:=$3
	
	$eCore_ValidValue:=New object:C1471()
	$oResult:=New object:C1471()
	
End if   //Done initialize

$eCore_ValidValue:=ds:C1482.Core_ValidValue.query("Category = :1 and Identifier =:2"; $tCategory; $tIdentifier).first()

$eCore_ValidValue.ValidValue:=$oValidValue

$oResult:=$eCore_ValidValue.save()
