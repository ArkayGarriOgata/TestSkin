//%attributes = {}
//Method:  Core_Cltn_ConvertT(cValue;nRow{;nColumn}=>tValue
//Description:  This method will convert value to text if needed

//Note: If you want to pass in a collection
//      that has only one column pass in the number 0
//      0 is the default value

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($1; $cValue)
	C_LONGINT:C283($2; $nRow; $3; $nColumn)
	C_TEXT:C284($0; $tValue)
	
	C_LONGINT:C283($nNumberOfParameters)
	
	$cValue:=$1
	$nRow:=$2
	$nColumn:=0
	$tValue:=CorektBlank
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=3)  //Parameters
		
		$nColumn:=$3
		
	End if   //Done parameters
	
End if   //Done initialize

$nType:=Core_Cltn_GetTypeN($cValue; $nRow; $nColumn)

If ($nColumn=0)  //One column
	
	Case of   //Type
			
		: ($nType=Is text:K8:3)
			
			$tValue:=$cValue[$nRow]
			
		: (($nType=Is real:K8:4) | ($nType=Is longint:K8:6))
			
			$tValue:=String:C10($cValue[$nRow])
			
		: ($nType=Is boolean:K8:9)
			
			$tValue:=Core_Convert_BooleanT($cValue[$nRow])
			
		: ($nType=Is date:K8:7)
			
			$tValue:=Core_Convert_DateT($cValue[$nRow])
			
		Else   //Ignore column 
			
			//Don't convert this type
			
	End case   //Done type
	
Else   //Muliple columns
	
	Case of   //Type
			
		: ($nType=Is text:K8:3)
			
			$tValue:=$cValue[$nColumn][$nRow]
			
		: (($nType=Is real:K8:4) | ($nType=Is longint:K8:6))
			
			$tValue:=String:C10($cValue[$nColumn][$nRow])
			
		: ($nType=Is boolean:K8:9)
			
			$tValue:=Core_Convert_BooleanT($cValue[$nColumn][$nRow])
			
		: ($nType=Is date:K8:7)
			
			$tValue:=Core_Convert_DateT($cValue[$nColumn][$nRow])
			
		Else   //Ignore column 
			
			//Don't convert this type
			
	End case   //Done type
	
End if   //Done one column

$0:=$tValue