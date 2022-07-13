//%attributes = {}
//Method:  Core_Convert_ToTextT(vObject{;nElement})=>tValue
//Description:  This method will convert most objects passed to it
//  and return the text version of it.  It converts numbers, dates, blobs, booleans and xml
//   all to the text value

If (True:C214)  //Initialize
	
	C_VARIANT:C1683($1; $vObject)
	C_LONGINT:C283($2; $nElement)
	C_TEXT:C284($0; $tValue)
	
	C_BOOLEAN:C305($bUseArray)
	C_BOOLEAN:C305($bUsePointer)
	
	C_LONGINT:C283($nObjectType)
	
	$vObject:=$1
	
	$bUseArray:=False:C215
	$bUsePointer:=False:C215
	
	If (Count parameters:C259>=2)
		$nElement:=$2
		$bUseArray:=True:C214
	End if 
	
	$tValue:=CorektBlank
	
	$nObjectType:=Value type:C1509($vObject)
	
	If ($nObjectType=Is pointer:K8:14)
		
		$nObjectType:=Type:C295($vObject)
		$bUsePointer:=True:C214
		
	End if 
	
End if   //Done initialize

Case of   //ObjectType
		
	: ($nObjectType=Text array:K8:16)
		
		$tValue:=$vObject->{$nElement}
		
	: ($nObjectType=String array:K8:15)
		
		$tValue:=$vObject->{$nElement}
		
	: ($bUseArray)
		
		$tValue:=String:C10($vObject->{$nElement})
		
	: ($nObjectType=Is text:K8:3)
		
		If ($bUsePointer)  //Pointer
			
			$tValue:=$vObject->
			
		Else   //Variant
			
			$tValue:=$vObject
			
		End if   //Done pointer
		
	: ($nObjectType=Is alpha field:K8:1)
		
		If ($bUsePointer)  //Pointer
			
			$tValue:=$vObject->
			
		Else   //Variant
			
			$tValue:=$vObject
			
		End if   //Done pointer
		
	: ($nObjectType=Is BLOB:K8:12)
		
		If ($bUsePointer)  //Pointer
			
			$tValue:=BLOB to text:C555($vObject->; UTF8 text without length:K22:17)
			
		Else   //Variant
			
			$tValue:=BLOB to text:C555($vObject; UTF8 text without length:K22:17)
			
		End if   //Done pointer
		
	: ($nObjectType=Is XML:K46:7)
		
		If ($bUsePointer)  //Pointer
			
			DOM EXPORT TO VAR:C863($vObject->; $tValue)
			
		Else   //Variant
			
			DOM EXPORT TO VAR:C863($vObject; $tValue)
			
		End if   //Done pointer
		
	Else   //All others
		
		If ($bUsePointer)  //Pointer
			
			$tValue:=String:C10($vObject->)
			
		Else   //Variant
			
			$tValue:=String:C10($vObject)
			
		End if   //Done pointer
		
End case   //Done object type

$0:=$tValue
