//%attributes = {"publishedWeb":true}
//(P) nGetPrcsName: get name of the passed process

C_LONGINT:C283($state; $1; $processID)
C_TEXT:C284($procName; $0)
C_LONGINT:C283($time)

If (Count parameters:C259=0)  //none passed
	$processID:=Current process:C322  //default to current
Else 
	$processID:=$1  //passed process id
End if 
PROCESS PROPERTIES:C336($processID; $procName; $state; $time)

$0:=$ProcName