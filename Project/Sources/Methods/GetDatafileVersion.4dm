//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 12/07/15, 10:59:22
// ----------------------------------------------------
// Method: GetDatafileVersion
// Description
// 
//
// Parameters
// ----------------------------------------------------

//[zz_control]

C_POINTER:C301($1; $2)

// Assumes current [Config] record

$1->:=String:C10([zz_control:1]UpdateVersion:64/100; "|dVersion")
$2->:=[zz_control:1]UpdateVersion:64

If ($2-><100)
	$1->:=$1->+" ß"
End if 

