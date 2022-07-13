//%attributes = {}
// _______
// Method: UTIL_Num_Entities   ( ) ->
// By: Mel Bohince @ 06/02/19, 11:55:43
// Description
// from 4D Essentials
// ----------------------------------------------------
C_POINTER:C301($1; $vpTable)
C_OBJECT:C1216($2; $sel)
C_TEXT:C284($0)
$vpTable:=$1
$sel:=$2

$0:=String:C10($sel.length)+" records of "+String:C10(Records in table:C83($vpTable->))+" found"

