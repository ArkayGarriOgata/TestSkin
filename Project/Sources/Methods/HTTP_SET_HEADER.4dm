//%attributes = {}
// _______
// Method: HTTP_SET_HEADER   ( ) ->
// By: Angelo @ 10/15/19, 15:36:53
// Description
// 
// ----------------------------------------------------

// HTTP_set_Header ("Vary";"Content-Encoding")
// $1:TEXT:headerName
// $2:TEXT:headerValue
// Adds an HTTP Header
C_TEXT:C284($1; $headerName; $2; $headerValue; $header)
$headerName:=$1
$headerValue:=$2
$header:=$1+": "+$2

WEB SET HTTP HEADER:C660($header)

