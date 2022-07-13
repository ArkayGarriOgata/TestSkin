//%attributes = {}
//Method:  Core_Array_Clear(paValue)
//Description:  This method will clear an array

If (True:C214)  //Initialize 
	
	C_POINTER:C301($1; $paValue)
	
	C_LONGINT:C283($nType)
	C_LONGINT:C283($nValue; $nNumberOfValues)
	
	C_BOOLEAN:C305($bValue)
	C_TEXT:C284($tValue)
	C_LONGINT:C283($nValue)
	C_REAL:C285($rValue)
	C_DATE:C307($dValue)
	C_TIME:C306($hValue)
	
	C_POINTER:C301($pDefaultValue)
	
	$paValue:=$1
	
	$nType:=Type:C295($paValue->)
	
	$nNumberOfValues:=Size of array:C274($paValue->)
	
End if   //Done Initialize

Case of   //Type
		
	: ($nType=Boolean array:K8:21)
		
		$bValue:=False:C215
		$pDefaultValue:=->$bValue
		
	: ($nType=Text array:K8:16)
		
		$tValue:=CorektBlank
		$pDefaultValue:=->$tValue
		
	: ($nType=LongInt array:K8:19)
		
		$nValue:=0
		$pDefaultValue:=->$nValue
		
	: ($nType=Real array:K8:17)
		
		$rValue:=0
		$pDefaultValue:=->$rValue
		
	: ($nType=Date array:K8:20)
		
		$dValue:=!00-00-00!
		$pDefaultValue:=->$dValue
		
	: ($nType=Time array:K8:29)
		
		$hValue:=?00:00:00?
		$pDefaultValue:=->$hValue
		
End case   //Done type

For ($nValue; 1; $nNumberOfValues)
	
	$paValue->{$nValue}:=$pDefaultValue->
	
End for 
