//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 12/28/15, 09:07:24
// ----------------------------------------------------
// Method: email_validate_address
// Description
// from http://kb.4d.com/assetid=76217
//
// ----------------------------------------------------

C_TEXT:C284($pattern_T; $address_T; $1)

$pattern_T:="(?i)^([A-Z0-9._%+-]+)@(?:[A-Z0-9_-]+\\.)+([A-Z]{2,4})$(.*)"
$address_T:=$1

If (Match regex:C1019($pattern_T; $address_T))
	$0:=True:C214
Else 
	$0:=False:C215
End if 
