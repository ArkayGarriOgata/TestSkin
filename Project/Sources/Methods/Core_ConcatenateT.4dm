//%attributes = {}
//Method:  Core_ConcatenateT(nFormat;pValue1{...;pValueN})=> tConcatenatedValue
//Description:  This method will concatenate 2 or more values together.
//  Ex:  nFormat (CoreknFormatCommaSpace, CoreknFormatSpace, CoreknFormatNoSpace)

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nFormat; $nNumberOfParameters)
	C_POINTER:C301(${2}; $pValue)
	C_TEXT:C284($0; $tConcatenatedValue)
	
	C_LONGINT:C283($nValue)
	C_TEXT:C284($tValue)
	
	$nFormat:=$1
	
	$tConcatenatedValue:=CorektBlank
	
End if   //Done Initialize

For ($nValue; 2; Count parameters:C259)  //Loop through the values
	
	$pValue:=${$nValue}
	
	$tValue:=Core_Convert_ToTextT($pValue)
	
	Case of 
			
		: ($tValue=CorektBlank)
			
		: ($tConcatenatedValue=CorektBlank)
			
			$tConcatenatedValue:=$tValue
			
		: ($nFormat=CoreknFormatNoSpace)
			
			$tConcatenatedValue:=$tConcatenatedValue+$tValue
			
		: ($nFormat=CoreknFormatSpace)
			
			$tConcatenatedValue:=$tConcatenatedValue+CorektSpace+$tValue
			
		: ($nFormat=CoreknFormatCommaSpace)
			
			$tConcatenatedValue:=$tConcatenatedValue+CorektComma+CorektSpace+$tValue
			
	End case 
	
End for   //Done looping through the values

$0:=$tConcatenatedValue