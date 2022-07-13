//%attributes = {}

// Method: util_RegisteredClient ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 04/04/14, 10:09:23
// ----------------------------------------------------
// Description
// importand to test return being less than one, the registration name newver disappears
//
// ----------------------------------------------------
C_TEXT:C284($target; $1)
$target:=$1
C_LONGINT:C283($hit; $bizy; $0)

ARRAY TEXT:C222($clients; 0)
ARRAY LONGINT:C221($methods; 0)
GET REGISTERED CLIENTS:C650($clients; $methods)

$hit:=Find in array:C230($clients; $target)
If ($hit>-1)
	$bizy:=$methods{$hit}
Else 
	$bizy:=-1
End if 

$0:=$bizy
