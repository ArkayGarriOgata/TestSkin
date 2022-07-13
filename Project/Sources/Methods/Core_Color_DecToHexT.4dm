//%attributes = {}
//Method:  Core_Color_DecToHexT(nDecimal)=>tRGBHexValue
//Description:  This method will take a decimal color value
//              and return the Hexadecimal RGB color value (base 16) 

// See:  https://discuss.4d.com/t/how-to-convert-decimal-colors-to-hex/16469

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nDecimal)
	C_TEXT:C284($0; $tRGBHexValue)
	
	$nDecimal:=$1
	
	$tRGBHexValue:=CorektBlank
	
End if   //Done inititialize

$tRGBHexValue:=Substring:C12(String:C10($nDecimal; "&x"); 3)  //Returns 4 or 8 hex digits

$tRGBHexValue:="#"+Substring:C12("00"+$tRGBHexValue; Length:C16($tRGBHexValue)-3)  //Returns $tRGBHexValue as #000000

$0:=$tRGBHexValue
