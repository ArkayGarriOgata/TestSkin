//%attributes = {}
// _______
// Method: WEB_Get_Vars   ( ) ->
// By: Angelo @ 10/15/19, 15:35:03
// Description
// 
// ----------------------------------------------------

// WEB_Get_Vars
C_OBJECT:C1216($0; $webVars)
ARRAY TEXT:C222($atVarNames; 0)
ARRAY TEXT:C222($atValues; 0)
WEB GET VARIABLES:C683($atVarNames; $atValues)

$webVars:=New object:C1471

For ($i; 1; Size of array:C274($atVarNames))
	$webVars[$atVarNames{$i}]:=$atValues{$i}
End for 

$0:=$webVars



