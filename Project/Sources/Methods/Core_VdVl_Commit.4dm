//%attributes = {}
//Method: Core_VdVl_Save(oCoreValidValue)
//Description:  This method saves a [Core_ValidValue] record

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oCoreValidValue)
	
	C_OBJECT:C1216($esCoreValidValue; $eCoreValidValue)
	C_OBJECT:C1216($oStatus)
	
	C_TEXT:C284($tCore_ValidValue)
	C_TEXT:C284($tQuery)
	
	$oCoreValidValue:=$1
	
	$esCoreValidValue:=New object:C1471()
	$eCoreValidValue:=New object:C1471()
	$oStatus:=New object:C1471()
	
	$tCore_ValidValue:=Table name:C256(->[Core_ValidValue:69])
	
	$tQuery:="Category = "+$oCoreValidValue.Category+" and "+\
		"Identifier = "+$oCoreValidValue.Identifier
	
End if   //Done initialize

$esCoreValidValue:=ds:C1482[$tCore_ValidValue].query($tQuery)

If ($esCoreValidValue.length=0)  //New
	
	$eCoreValidValue:=ds:C1482[$tCore_ValidValue].new()
	
Else   //Modify
	
	$eCoreValidValue:=$esCoreValidValue.first()
	
End if   //Done new

$eCoreValidValue.Category:=$oCoreValidValue.Category
$eCoreValidValue.Identifier:=$oCoreValidValue.Identifier
$eCoreValidValue.ValidValue:=$oCoreValidValue.ValidValue

UNLOAD RECORD:C212([Core_ValidValue:69])  //Make sure it is not locked

$oStatus:=$eCoreValidValue.save()
