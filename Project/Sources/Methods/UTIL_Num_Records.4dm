//%attributes = {}
// _______
// Method: UTIL_Num_Records   ( ) ->
// By: Mel Bohince @ 06/11/19, 16:26:29
// Description
// 
// ----------------------------------------------------

C_POINTER:C301($1; $vpTable)
C_TEXT:C284($0)
$vpTable:=$1

$0:=String:C10(Records in selection:C76($vpTable->))+" records of "+String:C10(Records in table:C83($vpTable->))+" found"
