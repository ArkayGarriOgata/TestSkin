//%attributes = {}
//Method:  Core_VdVl_GetValidValueO(tCategory;tIdentifier)=>oValidValue
//Description:  This method will get the valid values for name

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tCategory)
	C_TEXT:C284($2; $tIdentifier)
	
	C_OBJECT:C1216($0; $oValidValue)
	
	C_OBJECT:C1216($eCore_ValidValue)
	
	$tCategory:=$1
	$tIdentifier:=$2
	
	$oValidValue:=New object:C1471()
	
	$tCore_ValidValue:=Table name:C256(->[Core_ValidValue:69])
	
	$tQuery:="Category = "+$tCategory+" and Identifier = "+$tIdentifier
	
End if   //Done initialize

$eCore_ValidValue:=ds:C1482[$tCore_ValidValue].query($tQuery).first()

If (Not:C34(OB Is empty:C1297($eCore_ValidValue)))  //Found one
	
	$oValidValue:=$eCore_ValidValue.ValidValue
	
End if   //Done found one

$0:=$oValidValue