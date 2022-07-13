//%attributes = {}
//Method: Core_CoerciaionT(pObject)=>tValue
//Description: This method will convert to text

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pObject)
	C_TEXT:C284($0; $tValue)
	
	C_LONGINT:C283($nObjectType)
	
	$pObject:=$1
	
	$tValue:=CorektBlank
	
	$nObjectType:=Type:C295($pObject->)
	
End if   //Done initialize

Case of   //Type
		
	: ($nObjectType=Is alpha field:K8:1)
		
		$tValue:=$pObject->
		
	: ($nObjectType=Is text:K8:3)
		
		$tValue:=$pObject->
		
	: ($nObjectType=Is longint:K8:6)
		
		$tValue:=String:C10($pObject->)
		
	: ($nObjectType=Is real:K8:4)
		
		$tValue:=String:C10($pObject->)
		
	: ($nObjectType=Is integer:K8:5)
		
		$tValue:=String:C10($pObject->)
		
	: ($nObjectType=Is integer 64 bits:K8:25)
		
		$tValue:=String:C10($pObject->)
		
	: ($nObjectType=Is date:K8:7)
		
		$tValue:=String:C10($pObject->; System date short:K1:1)
		
	: ($nObjectType=Is time:K8:8)
		
		$tValue:=String:C10($pObject->; ISO time:K7:8)
		
	: ($nObjectType=Is boolean:K8:9)
		
		$tValue:=Choose:C955($pObject->; "True"; "False")
		
End case   //Done type

$0:=$tValue