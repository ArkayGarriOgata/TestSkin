//%attributes = {}
//Method:  Core_State_Abbreviation(oAbbreviation;tState)
//Description:  This method finds the state by abbreviation

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oAbbreviation)
	C_TEXT:C284($2; $tState)
	
	$oAbbreviation:=New object:C1471()
	$oAbbreviation:=$1
	
	$tState:=$2
	
End if   //Done initialize

$oAbbreviation.result:=$oAbbreviation.value.tAbbreviation=$tState
