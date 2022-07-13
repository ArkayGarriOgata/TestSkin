//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/18/10, 16:25:15
// ----------------------------------------------------
// Method: edi_filter_delimiters
// Description
// remove :+' from text so that it doesn't mess up an edi response
// ----------------------------------------------------

C_TEXT:C284($1; $theText; $0)

$theText:=$1
$theText:=Replace string:C233($theText; ":"; "-")
$theText:=Replace string:C233($theText; "+"; "-")
$theText:=Replace string:C233($theText; Char:C90(Quote:K15:44); "-")
$theText:=Replace string:C233($theText; Char:C90(Double quote:K15:41); "-")
$0:=$theText