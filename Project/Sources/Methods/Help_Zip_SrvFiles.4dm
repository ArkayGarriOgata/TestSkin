//%attributes = {}
// ----------------------------------------------------
// User name (OS): Logan Richards
// Date and time: 07/01/22, 10:03:49
// ----------------------------------------------------
// Method: Help_Zip_SrvFiles
// Description
// 
//
// Parameters
// ----------------------------------------------------

If (True:C214)
	
	C_OBJECT:C1216($1; $oPath)
	C_OBJECT:C1216($2; $oDestination)
	C_OBJECT:C1216($3; $oStatus)
	
	$oPath:=$1
	$oDestination:=$2
	$oStatus:=$3
	
End if 

$oStatus:=ZIP Create archive:C1640($oPath; $oDestination)