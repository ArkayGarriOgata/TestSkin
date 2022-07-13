//%attributes = {}
//Method:  Core_Array_PositionN(patSource;tFind)=>nLocation
//Description:  This method will find any where x is in array

If (True:C214)  //Initialize 
	
	C_LONGINT:C283($0; $nLocation)
	C_POINTER:C301($1; $patSource)
	C_TEXT:C284($2; $tFind)
	
	$patSource:=$1
	$tFind:=$2
	
	$nLocation:=CoreknNoMatchFound
	
End if   //Done Initialize

$nLocation:=Find in array:C230($patSource->; "@"+$tFind+"@")

$0:=$nLocation
