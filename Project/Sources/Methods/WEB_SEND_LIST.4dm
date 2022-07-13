//%attributes = {}
// _______
// Method: WEB_SEND_LIST   ( ) ->
// By: Angelo @ 10/15/19, 15:39:12
// Description
// 
// ----------------------------------------------------
// WEB_SEND_LIST  
// Description
// Fill out a JSON list with the selected records
//
// Parameters
// $1 Entity selection
// $2 Attributes
// $3 Stats: total of records, offset, length
// ----------------------------------------------------

C_TEXT:C284($attribs; $2)
C_OBJECT:C1216($selEnts; $1; $obResponse; $3; $stats)
C_TEXT:C284($json)

$selEnts:=$1
$attribs:=$2
$stats:=$3

$obResponse:=New object:C1471("stats"; $stats; "data"; $selEnts.toCollection($attribs; dk with primary key:K85:6))
$json:=JSON Stringify:C1217($obResponse; *)

WEB SEND TEXT:C677($json; "application/json")
