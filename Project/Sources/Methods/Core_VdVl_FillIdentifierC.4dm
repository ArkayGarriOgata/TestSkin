//%attributes = {}
//Method:  Core_VdVl_FillNameC(tCategory)=>cIdentifier
//Description: This method fills collection of all Names with Category

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tCategory)
	
	C_COLLECTION:C1488($0; $cIdentifier)
	
	C_TEXT:C284($tCore_ValidValue; $tQuery)
	
	C_OBJECT:C1216($esCoreValidValue)
	
	$tCategory:=$1
	
	$cIdentifier:=New collection:C1472()
	
	$tCore_ValidValue:=Table name:C256(->[Core_ValidValue:69])
	
	$tQuery:="Category = "+$tCategory
	
	$esCoreValidValue:=New object:C1471()
	
End if   //Done initialize

$esCoreValidValue:=ds:C1482[$tCore_ValidValue].query($tQuery)

$cIdentifier:=$esCoreValidValue.toCollection("Identifier")

$0:=$cIdentifier
