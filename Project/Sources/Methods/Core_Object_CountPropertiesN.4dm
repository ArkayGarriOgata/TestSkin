//%attributes = {}
//Method:  Core_Object_CountPropertiesN(poObject;tProperty)=>nNumberOfProperties
//Description:  This method returns the count of elemets in Property

If (True:C214)  //Initialize 
	
	C_LONGINT:C283($0; $nNumberOfProperties)
	C_POINTER:C301($1; $poObject)
	C_TEXT:C284($2; $tProperty)
	
	ARRAY OBJECT:C1221($aoProperty; 0)
	
	$poObject:=$1
	$tProperty:=$2
	
	$nNumberOfProperties:=0
	
End if   //Done Initialize

If (OB Is defined:C1231($poObject->; $tProperty))  //Property exists
	
	OB GET ARRAY:C1229($poObject->; $tProperty; $aoProperty)
	
	$nNumberOfProperties:=Size of array:C274($aoProperty)
	
End if   //Done property exists

$0:=$nNumberOfProperties
