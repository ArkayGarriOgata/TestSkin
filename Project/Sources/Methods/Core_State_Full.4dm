//%attributes = {}
//Method:  Core_State_Full(oFull;tState)
//Description:  This method finds the state by Full

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oFull)
	C_TEXT:C284($2; $tState)
	
	$oFull:=New object:C1471()
	$oFull:=$1
	
	$tState:=$2
	
End if   //Done initialize

$oFull.result:=$oFull.value.tFull=$tState
