//%attributes = {}
// Method: util_Quote () -> 
// ----------------------------------------------------
// by: mel: 10/29/04, 15:51:08
// ----------------------------------------------------
// Description:
// return expression in quotes
// see also txt_quote

C_TEXT:C284($Q)
C_TEXT:C284($1; $0)

$Q:=Char:C90(Double quote:K15:41)
$0:=$Q+$1+$Q