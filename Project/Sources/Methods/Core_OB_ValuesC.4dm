//%attributes = {}
//Method:  Core_OB_ValuesC(oAttributeValue)->cValue
//Description:  This method returns a collection of values

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oAttributeValue)
	C_COLLECTION:C1488($0; $cValue)
	
	C_TEXT:C284($tAttribute)
	
	$oAttributeValue:=$1
	
	$cValue:=New collection:C1472()
	$tAttribute:=CorektBlank
	
End if   //Done initialize

For each ($tAttribute; $oAttributeValue)  //Attribute
	
	$cValue.push(OB Get:C1224($oAttributeValue; $tAttribute; Is text:K8:3))
	
End for each   //Done attribute

$0:=$cValue