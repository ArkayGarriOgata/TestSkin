//%attributes = {}
//Method:  Core_OB_IsValidB(poObject;tProperty)=>bValid
//Description: This method verifies object contains attribute
//.  and attribute has a valid value for its type

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $poObject)
	C_TEXT:C284($2; $tProperty)
	C_BOOLEAN:C305($0; $bValid)
	
	$poObject:=$1
	$tProperty:=$2
	
	$bValid:=False:C215
	
End if   //Done initialize

Case of   //Verify
		
	: (OB Is empty:C1297($poObject->))
	: (Not:C34(OB Is defined:C1231($poObject->; $tProperty)))
		
	Else 
		
		$nType:=OB Get type:C1230($poObject->; $tProperty)
		
		Case of   //Type
				
			: ($nType=Is boolean:K8:9)
				
				$bValid:=True:C214
				
			: ($nType=Is collection:K8:32)
				
				$bValid:=True:C214
				
			: ($nType=Is date:K8:7)
				
				$bValid:=(OB Get:C1224($poObject->; $tProperty; Is date:K8:7)#!00-00-00!)
				
			: ($nType=Is null:K8:31)
				
				$bValid:=True:C214
				
			: ($nType=Is object:K8:27)
				
				$bValid:=True:C214
				
			: ($nType=Is real:K8:4)
				
				$bValid:=True:C214
				
			: ($nType=Is text:K8:3)
				
				$bValid:=(OB Get:C1224($poObject->; $tProperty; Is text:K8:3)#CorektBlank)
				
			: ($nType=Is undefined:K8:13)
				
		End case   //Done type
		
End case   //Done verify

$0:=$bValid