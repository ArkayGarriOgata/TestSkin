//%attributes = {}
// _______
// Method: eLogAnError   ( ) ->
// By: Mel Bohince @ 04/13/20, 09:29:15
// Description
// 
// ----------------------------------------------------

ARRAY LONGINT:C221($errCodes; 0)
ARRAY TEXT:C222($comps; 0)
ARRAY TEXT:C222($errMsgs; 0)

GET LAST ERROR STACK:C1015($errCodes; $comps; $errMsgs)
$method:=error method
$line:=String:C10(error line)

For ($i; 1; Size of array:C274($errCodes))
	$msg:=String:C10($errCodes{$i})+" "+$comps{$i}+" "+$errMsgs{$i}+" called in "+$method+" at line "+$line
	
	utl_LogfileServer(<>zResp; $msg; "BatchRunner.Log")
End for 

