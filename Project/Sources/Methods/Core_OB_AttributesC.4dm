//%attributes = {}
//Method:  Core_OB_AttributesC(oAttributeValue)=>cAttribute
//Description:  This method will get the attributes of an object 

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oAttributeValue)
	C_COLLECTION:C1488($0; $cAttribute)
	
	C_TEXT:C284($tAttribute)
	
	$oAttributeValue:=$1
	
	$cAttribute:=New collection:C1472()
	
End if   //Done initialize

For each ($tAttribute; $oAttributeValue)
	
	$cAttribute.push($tAttribute)
	
End for each 

$0:=$cAttribute