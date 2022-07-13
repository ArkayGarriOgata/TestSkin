//%attributes = {}
//Method:  Core_Country_Abbreviation(oAbbreviation;tCountry)
//Description:  This method finds the Country by abbreviation

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oAbbreviation)
	C_TEXT:C284($2; $tCountry)
	
	$oAbbreviation:=New object:C1471()
	$oAbbreviation:=$1
	
	$tCountry:=$2
	
End if   //Done initialize

$oAbbreviation.result:=$oAbbreviation.value.tAbbreviation=$tCountry
