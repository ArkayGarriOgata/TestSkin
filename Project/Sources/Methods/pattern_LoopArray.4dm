//%attributes = {"publishedWeb":true}
//PM: pattern_LoopArray() -> 
//@author mlb - 8/27/02  16:32

C_LONGINT:C283($i; $numElements)

$numElements:=Size of array:C274(aCollection)

uThermoInit($numElements; "Processing Array")
For ($i; 1; $numElements)
	aCollection{$i}:=0
	uThermoUpdate($i)
End for 
uThermoClose